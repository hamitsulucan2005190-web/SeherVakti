import SwiftUI
import SwiftData

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    @Environment(\.modelContext) private var modelContext
    
    // Veri Kaynakları (SwiftData)
    @Query private var logs: [PrayerLog]
    @Query private var dhikrLogs: [DhikrLog]
    @Query private var focusLogs: [FocusLog]
    
    // Kullanıcı Ayarları
    @AppStorage("userName") private var userName: String = "Misafir"
    @AppStorage("userCity") private var userCity: String = "İstanbul"
    
    // MARK: - Helpers
    
    // Bugünün tarihini formatlı döndüren özellik
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM, EEEE"
        return formatter.string(from: Date())
    }
    
    // Namaz serisini (Streak) hesaplayan fonksiyon
    private func calculateStreak() -> Int {
        let calendar = Calendar.current
        let dates = logs.map { calendar.startOfDay(for: $0.date) }
        let uniqueDates = Array(Set(dates)).sorted(by: >)
        
        guard let firstDate = uniqueDates.first else { return 0 }
        
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        if firstDate < yesterday { return 0 }
        
        var streak = 0
        var checkDate = firstDate
        
        for date in uniqueDates {
            if date == checkDate {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                break
            }
        }
        return streak
    }
    
    // Dün çekilen toplam zikir sayısı
    private var yesterdayDhikrCount: Int {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: Date()))!
        return dhikrLogs
            .filter { Calendar.current.isDate($0.date, inSameDayAs: yesterday) }
            .reduce(0) { $0 + $1.count }
    }
    
    // Dün yapılan odaklanma süresi (Dakika)
    private var yesterdayFocusMinutes: Int {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: Date()))!
        return focusLogs
            .filter { Calendar.current.isDate($0.date, inSameDayAs: yesterday) }
            .reduce(0) { $0 + $1.durationMinutes } // Modeldeki gerçek alan adı buydu
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // 1. Selamlama ve Tarih
                headerSection
                
                // 2. Seri (Streak) Kartı
                StreakCard(streakCount: calculateStreak())
                
                // 3. Vakit Yükleme Durumu
                if viewModel.isLoading {
                    ProgressView("Vakitler Yükleniyor...").padding()
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red).font(.caption)
                }
                
                // 4. Sonraki Vakit Kartı
                if let next = viewModel.nextPrayer {
                    NextPrayerCard(prayer: next, countDown: viewModel.timeRemaining)
                }
                
                // 5. Bugünün Vakit Listesi
                VStack(spacing: 12) {
                    Text("Bugünkü Vakitler")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(viewModel.prayerTimes, id: \.name) { prayer in
                        let isDone = logs.contains(where: { $0.prayerName == prayer.name })
                        PrayerRow(prayer: prayer, isCompleted: isDone) {
                            togglePrayer(prayer)
                        }
                    }
                }
                
                // 6. Dünkü İstatistikler (Sadece veri varsa görünür)
                if yesterdayDhikrCount > 0 || yesterdayFocusMinutes > 0 {
                    HStack(spacing: 12) {
                        if yesterdayDhikrCount > 0 {
                            MiniStatCard(
                                title: "Dün Zikir",
                                value: "\(yesterdayDhikrCount) Adet",
                                icon: "bolt.heart.fill",
                                color: .red
                            )
                        }
                        
                        if yesterdayFocusMinutes > 0 {
                            MiniStatCard(
                                title: "Dün Odak",
                                value: "\(yesterdayFocusMinutes) Dakika",
                                icon: "book.fill",
                                color: .blue
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 30)
            .onChange(of: userCity) {
                Task { await viewModel.fetchPrayerTimes() }
            }
        }
        .background(AppTheme.Colors.background.ignoresSafeArea())
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(formattedDate)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
            
            Text("Hayırlı Sabahlar,\n\(userName)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .lineSpacing(4)
                .foregroundColor(AppTheme.Colors.primary)
        }
        .padding(.top, 20)
    }
    
    private func togglePrayer(_ prayer: PrayerTime) {
        if let existingLog = logs.first(where: { $0.prayerName == prayer.name }) {
            modelContext.delete(existingLog)
        } else {
            let newLog = PrayerLog(prayerName: prayer.name)
            modelContext.insert(newLog)
        }
    }
}

// MARK: - Supporting Views

struct StreakCard: View {
    let streakCount: Int
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle().fill(Color.orange.opacity(0.2)).frame(width: 50, height: 50)
                Text("🔥").font(.system(size: 25))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("\(streakCount) Günlük Seri!").font(.system(.headline, design: .rounded))
                Text(streakCount > 0 ? "Maşallah, bozmadan devam et!" : "Bugün bir kayıt gir ve seriyi başlat!")
                    .font(.system(.caption, design: .rounded)).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding().background(AppTheme.Colors.surfaceLow).cornerRadius(15)
    }
}

struct MiniStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).foregroundColor(color).font(.system(size: 14, weight: .bold))
            Text(value).font(.system(.subheadline, design: .rounded).weight(.bold))
            Text(title).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12).background(AppTheme.Colors.surfaceLow).cornerRadius(12)
    }
}

#Preview {
    DashboardView()
}
