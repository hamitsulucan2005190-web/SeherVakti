import SwiftUI
import SwiftData

struct HistoryView: View {

    // --- VERİ: SwiftData'dan tüm geçmiş kayıtları çekiyoruz ---
    @Query(sort: \PrayerLog.date, order: .reverse)
    private var prayerLogs: [PrayerLog]

    @Query(sort: \FocusLog.date, order: .reverse)
    private var focusLogs: [FocusLog]

    @Query(sort: \DhikrLog.date, order: .reverse)
    private var dhikrLogs: [DhikrLog]

    // Segment filtresi: 0=Tümü, 1=Namaz, 2=Odak, 3=Zikir
    @State private var selectedSegment: Int = 0
    
    // --- VIEWMODEL VE UI STATE ---
    @State private var viewModel = HistoryViewModel.shared // İş mantığını yöneten ViewModel
    @State private var showKazaSheet: Bool = false    // Sheet'in açılıp kapanma durumu

    //  SwiftData Veritabanı Bağlamı
    @Environment(\.modelContext) private var modelContext



    var body: some View {
        NavigationStack {
            ZStack {
                // Tema arka planı
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {                       
                        // --- 1. BUGÜNKÜ ÖZET KARTI ---
                        summaryCard
                            .padding(.horizontal, 20)
                            .padding(.top, 10)

                        // --- 2. KAZA BORÇ ÖZET KARTI ---
                        if viewModel.hasAnyDebt {
                            kazaSummaryCard
                                .padding(.horizontal, 20)
                        }

                        // --- 3. KATEGORİ FİLTRELEME ---
                        Picker("Kategori", selection: $selectedSegment) {
                            Text("Tümü").tag(0)
                            Text("Namaz").tag(1)
                            Text("Odak").tag(2)
                            Text("Zikir").tag(3)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)

                        // --- 4. GEÇMİŞ LİSTESİ ---
                        historyListContent
                    }
                    .padding(.bottom, 30)
                    .animation(.easeInOut(duration: 0.2), value: selectedSegment)
                }
            }
            .navigationTitle("İbadet Takibi")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showKazaSheet) {
                // Yeni bağımsız View bileşeni
                KazaManagementView(viewModel: viewModel)
            }
        }
        .onAppear {
            // Ekran açıldığı an veritabanını başlat ve verileri yükl
            viewModel.setup(context: modelContext)
        }
    }

    // --- GEÇMİŞ LİSTESİ İÇERİĞİ ---
    @ViewBuilder
    private var historyListContent: some View {
        if selectedSegment == 0 || selectedSegment == 1 {
            sectionView(title: "🕌 Namaz Kayıtları", isEmpty: prayerLogs.isEmpty) {
                ForEach(prayerLogs) { log in
                    logRow(icon: "checkmark.circle.fill", iconColor: .green, title: log.prayerName, detail: log.date.formatted(date: .abbreviated, time: .shortened), badge: "KILINDI")
                }
            }
        }

        if selectedSegment == 0 || selectedSegment == 2 {
            sectionView(title: "🧠 Odak Seansları", isEmpty: focusLogs.isEmpty) {
                ForEach(focusLogs) { log in
                    logRow(icon: "brain.head.profile", iconColor: AppTheme.Colors.primary, title: log.title, detail: log.date.formatted(date: .abbreviated, time: .shortened), badge: "\(log.durationMinutes) dk")
                }
            }
        }

        if selectedSegment == 0 || selectedSegment == 3 {
            sectionView(title: "📿 Zikir Seansları", isEmpty: dhikrLogs.isEmpty) {
                ForEach(dhikrLogs) { log in
                    logRow(icon: "circle.dotted", iconColor: .orange, title: log.title, detail: log.date.formatted(date: .abbreviated, time: .shortened), badge: "\(log.count) adet")
                }
            }
        }
    }

    // --- BUGÜNKÜ ÖZET BİLEŞENİ ---
    private var summaryCard: some View {
        let stats = viewModel.calculateTodayStats(prayerLogs: prayerLogs, focusLogs: focusLogs, dhikrLogs: dhikrLogs)

        return VStack(spacing: 16) {
            Text("Bugünkü Özet").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                statItem(value: "\(stats.prayerCount)", label: "Namaz", color: .green)
                Divider().frame(height: 40)
                statItem(value: "\(stats.focusMinutes)dk", label: "Odak", color: AppTheme.Colors.primary)
                Divider().frame(height: 40)
                statItem(value: "\(stats.dhikrCount)", label: "Zikir", color: .orange)
            }
        }
        .padding(20).background(AppTheme.Colors.surfaceLowest).clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard)).shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    // --- KAZA ÖZET KARTI ---
    private var kazaSummaryCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Kaza Borç Takibi").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.secondary)
                Spacer()
                Text("%\(viewModel.completionPercentage) tamamlandı").font(.system(size: 12, weight: .bold, design: .rounded)).foregroundColor(AppTheme.Colors.primary)
            }
            
            if viewModel.totalNamazDebt > 0 {
                VStack(spacing: 8) {
                    HStack {
                        Text("Toplam Namaz Borcu").font(.system(size: 15, weight: .semibold, design: .rounded))
                        Spacer()
                        Text("\(viewModel.totalNamazCompleted)/\(viewModel.totalNamazDebt)").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(AppTheme.Colors.primary.opacity(0.1)).frame(height: 10)
                            Capsule().fill(AppTheme.Colors.primary.gradient)
                                .frame(width: geo.size.width * CGFloat(Double(viewModel.totalNamazCompleted) / Double(max(viewModel.totalNamazDebt, 1))), height: 10)
                        }
                    }
                    .frame(height: 10)
                }
            }

            Button { showKazaSheet = true } label: {
                HStack { Image(systemName: "pencil.and.outline"); Text("Kazaları Yönet / Kıl") }
                .font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 12).background(AppTheme.Colors.primary).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20).background(AppTheme.Colors.surfaceLowest).clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard)).shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    // --- YARDIMCI BİLEŞENLER ---
    private func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 22, weight: .bold, design: .rounded)).foregroundColor(color)
            Text(label).font(.system(size: 12, weight: .medium, design: .rounded)).foregroundColor(.secondary)
        }.frame(maxWidth: .infinity)
    }

    private func sectionView<Content: View>(title: String, isEmpty: Bool, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.system(size: 16, weight: .bold, design: .rounded)).foregroundColor(AppTheme.Colors.primary).padding(.horizontal, 20)
            if isEmpty { Text("Henüz kayıt yok").font(.system(size: 14, design: .rounded)).foregroundColor(.secondary).padding(.horizontal, 20) } 
            else { content() }
        }
    }

    private func logRow(icon: String, iconColor: Color, title: String, detail: String, badge: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).font(.title3).foregroundColor(iconColor).frame(width: 40, height: 40).background(iconColor.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) { Text(title).font(.system(size: 15, weight: .semibold, design: .rounded)).foregroundColor(.primary); Text(detail).font(.caption).foregroundColor(.secondary) }
            Spacer()
            Text(badge).font(.system(size: 11, weight: .bold)).foregroundColor(.white).padding(.horizontal, 8).padding(.vertical, 4).background(iconColor).clipShape(Capsule())
        }
        .padding(14).background(AppTheme.Colors.surfaceLowest).clipShape(RoundedRectangle(cornerRadius: 14)).padding(.horizontal, 20)
    }
}

#Preview {
    HistoryView()
}
