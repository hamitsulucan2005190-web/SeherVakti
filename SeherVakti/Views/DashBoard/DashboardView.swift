import SwiftUI
import SwiftData

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var logs: [PrayerLog]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                
                NextPrayerCard(prayer: viewModel.nextPrayer, countDown: viewModel.timeRemaining)
                
                VStack(spacing: 12) {
                    Text("Bugünkü Vakitler")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    ForEach(viewModel.prayerTimes, id: \.name) { prayer in
                        // Döngü içinde değişkeni bu şekilde güvenle kullanabiliriz
                        let isDone = logs.contains(where: { $0.prayerName == prayer.name })
                        
                        PrayerRow(prayer: prayer, isCompleted: isDone) {
                            togglePrayer(prayer)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 30)
        }
        .background(AppTheme.Colors.background.ignoresSafeArea())
    }
    // başlık bölümü 
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("14 Nisan 2026")
                .font(.system(.subheadline, design : .rounded)) // yuvarlak hatlı yazı tipi  
                .foregroundColor(.secondary)
            
            Text("Hayırlı Sabahlar,\nSelamün Aleyküm")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .lineSpacing(4) // satır aralığı
                .foregroundColor(AppTheme.Colors.primary)
        }
        .padding(.top,20)
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


#Preview {
    DashboardView()
}

