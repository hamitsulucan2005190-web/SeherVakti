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
    
    // Genel bir seri hesaplama fonksiyonu (Herhangi bir tarih listesi alır)
    private func calculateStreak(from  dates : [Date]) -> Int {
        let calendar = Calendar.current
        let uniqueDates = Array(Set(dates.map { calendar.startOfDay(for: $0) })).sorted(by: >)

        
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

    // Kategorilere göre serileri ayrı ayrı hesaplıyoruz
    private var prayerStreak: Int { calculateStreak(from: logs.map { $0.date }) }
    private var focusStreak: Int { calculateStreak(from: focusLogs.map { $0.date }) }
    private var dhikrStreak: Int { calculateStreak(from: dhikrLogs.map { $0.date }) }

    
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
                
                // seri (streak kartları )
                 HStack(spacing: 12) {
                    MiniStreakCard(title: "Namaz", icon: "🕌", streak: prayerStreak, color: .green)
                    MiniStreakCard(title: "Odak", icon: "🧠", streak: focusStreak, color: AppTheme.Colors.primary)
                    MiniStreakCard(title: "Zikir", icon: "📿", streak: dhikrStreak, color: .orange)
                }
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

// Yan yana dizilecek küçük seri kartları
struct MiniStreakCard: View {
    let title: String
    let icon: String
    let streak: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 40, height: 40)
                Text(icon).font(.system(size: 20))
            }
            Text("\(streak) Gün")
                .font(.system(size: 14, weight: .bold, design: .rounded))
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppTheme.Colors.surfaceLowest)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
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
