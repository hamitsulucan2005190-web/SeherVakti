//
//  HistoryView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 30.04.2026.
//


import SwiftUI
import SwiftData

struct HistoryView: View {

    // --- VERİ: SwiftData'dan tüm kayıtları çekiyoruz ---
    // En yeni kayıt en üstte görünsün diye .reverse sıralama
    @Query(sort: \PrayerLog.date, order: .reverse)
    private var prayerLogs: [PrayerLog]

    @Query(sort: \FocusLog.date, order: .reverse)
    private var focusLogs: [FocusLog]

    @Query(sort: \DhikrLog.date, order: .reverse)
    private var dhikrLogs: [DhikrLog]

    // Segment filtresi: 0=Tümü, 1=Namaz, 2=Odak, 3=Zikir
    @State private var selectedSegment: Int = 0
        // --- KAZA TAKİP DEĞİŞKENLERİ ---
    @AppStorage("kazaNamazTotal") private var kazaNamazTotal: Int = 0
    @AppStorage("kazaNamazCompleted") private var kazaNamazCompleted: Int = 0
    
    @AppStorage("kazaOrucTotal") private var kazaOrucTotal: Int = 0
    @AppStorage("kazaOrucCompleted") private var kazaOrucCompleted: Int = 0


    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // --- 1. ÖZET KART (Bugünün istatistikleri) ---
                        summaryCard
                            .padding(.horizontal, 20)
                            .padding(.top, 10)

                            // kaza borç kartı 
                              // Sadece bir borç girilmişse bu kartı gösteriyoruz
                        if kazaNamazTotal > 0 || kazaOrucTotal > 0 {
                            kazaCard
                                .padding(.horizontal, 20)
                        }
                            


                        // --- 2. FİLTRE ÇUBUĞU ---
                        Picker("Kategori", selection: $selectedSegment) {
                            Text("Tümü").tag(0)
                            Text("Namaz").tag(1)
                            Text("Odak").tag(2)
                            Text("Zikir").tag(3)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)

                        // --- 3. LİSTE (Seçime Göre) ---
                        if selectedSegment == 0 || selectedSegment == 1 {
                            sectionView(
                                title: "🕌 Namaz Kayıtları",
                                isEmpty: prayerLogs.isEmpty
                            ) {
                                ForEach(prayerLogs) { log in
                                    logRow(
                                        icon: "checkmark.circle.fill",
                                        iconColor: .green,
                                        title: log.prayerName,
                                        detail: "\(log.date.formatted(date: .abbreviated, time: .shortened))",
                                        badge: "KILINDI"
                                    )
                                }
                            }
                        }

                        if selectedSegment == 0 || selectedSegment == 2 {
                            sectionView(
                                title: "🧠 Odak Seansları",
                                isEmpty: focusLogs.isEmpty
                            ) {
                                ForEach(focusLogs) { log in
                                    logRow(
                                        icon: "brain.head.profile",
                                        iconColor: AppTheme.Colors.primary,
                                        title: log.title,
                                        detail: log.date.formatted(date: .abbreviated, time: .shortened),
                                        badge: "\(log.durationMinutes) dk"
                                    )
                                }
                            }
                        }

                        if selectedSegment == 0 || selectedSegment == 3 {
                            sectionView(
                                title: "📿 Zikir Seansları",
                                isEmpty: dhikrLogs.isEmpty
                            ) {
                                ForEach(dhikrLogs) { log in
                                    logRow(
                                        icon: "circle.dotted",
                                        iconColor: .orange,
                                        title: log.title,
                                        detail: log.date.formatted(date: .abbreviated, time: .shortened),
                                        badge: "\(log.count) adet"
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    .animation(.easeInOut(duration: 0.2), value: selectedSegment)
                }
            }
            .navigationTitle("İbadet Takibi")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // --- ÖZET KART: Bugünün sayıları ---
    private var summaryCard: some View {
        // Bugünün başlangıç saati
        let startOfToday = Calendar.current.startOfDay(for: .now)

        // Bugüne ait kayıtları filtrele
        let todayPrayers = prayerLogs.filter { $0.date >= startOfToday }.count
        let todayFocusMin = focusLogs.filter { $0.date >= startOfToday }.reduce(0) { $0 + $1.durationMinutes }
        let todayDhikr = dhikrLogs.filter { $0.date >= startOfToday }.reduce(0) { $0 + $1.count }

        return VStack(spacing: 16) {
            Text("Bugünkü Özet")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                // Namaz sayısı
                statItem(value: "\(todayPrayers)", label: "Namaz", color: .green)
                Divider().frame(height: 40)
                // Odak dakikası
                statItem(value: "\(todayFocusMin)dk", label: "Odak", color: AppTheme.Colors.primary)
                Divider().frame(height: 40)
                // Zikir adedi
                statItem(value: "\(todayDhikr)", label: "Zikir", color: .orange)
            }
        }
        .padding(20)
        .background(AppTheme.Colors.surfaceLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }
        // --- KAZA BORÇ KARTI ---
    private var kazaCard: some View {
        VStack(spacing: 16) {
            Text("Kaza Borç Takibi")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Eğer namaz borcu 0'dan büyükse namazı göster
            if kazaNamazTotal > 0 {
                kazaProgressRow(
                    icon: "clock.arrow.circlepath",
                    color: .blue,
                    title: "Kaza Namazı",
                    completed: kazaNamazCompleted,
                    total: kazaNamazTotal,
                    action: { kazaNamazCompleted += 1 } // Butona basınca +1 artır
                )
            }
            
            // Eğer ikisi de varsa araya çizgi çek
            if kazaNamazTotal > 0 && kazaOrucTotal > 0 {
                Divider()
            }
            
            // Eğer oruç borcu 0'dan büyükse orucu göster
            if kazaOrucTotal > 0 {
                kazaProgressRow(
                    icon: "moon.stars.fill",
                    color: .indigo,
                    title: "Kaza Orucu",
                    completed: kazaOrucCompleted,
                    total: kazaOrucTotal,
                    action: { kazaOrucCompleted += 1 } // Butona basınca +1 artır
                )
            }
        }
        .padding(20)
        .background(AppTheme.Colors.surfaceLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    // --- KAZA İLERLEME ÇUBUĞU (TEKİL SATIR) ---
    private func kazaProgressRow(icon: String, color: Color, title: String, completed: Int, total: Int, action: @escaping () -> Void) -> some View {
        // İlerleme yüzdesini hesapla (0.0 ile 1.0 arası)
        let progress = min(Double(completed) / Double(total), 1.0)
        
        return VStack(spacing: 12) {
            // İkon, Başlık ve Sayılar
            HStack {
                Image(systemName: icon).foregroundColor(color).font(.title3)
                Text(title).font(.system(size: 16, weight: .bold, design: .rounded))
                Spacer()
                Text("\(completed)/\(total)")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            // Custom Progress Bar (Stitch UX)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule() // Zemin
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                    
                    Capsule() // Dolgulu Kısım
                        .fill(color)
                        .frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8) // Barın yüksekliği
            
            // Kaza Ekle Butonu
            Button(action: action) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Bugün Kaza Yaptım")
                }
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            // Borç bittiyse butonu devre dışı bırak
            .disabled(completed >= total)
            .opacity(completed >= total ? 0.5 : 1.0)
        }
    }



    // Özet kartındaki tek bir istatistik bileşeni
    private func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // Bölüm başlığı + içerik sarmalayıcı
    private func sectionView<Content: View>(
        title: String,
        isEmpty: Bool,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.Colors.primary)
                .padding(.horizontal, 20)

            if isEmpty {
                Text("Henüz kayıt yok")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
            } else {
                content()
            }
        }
    }

    // Tek bir log satırı bileşeni
    private func logRow(icon: String, iconColor: Color, title: String, detail: String, badge: String) -> some View {
        HStack(spacing: 14) {
            // İkon
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // Başlık ve tarih
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                Text(detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Rozet
            Text(badge)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(iconColor)
                .clipShape(Capsule())
        }
        .padding(14)
        .background(AppTheme.Colors.surfaceLowest)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20)
    }
}

#Preview {
    HistoryView()
}
