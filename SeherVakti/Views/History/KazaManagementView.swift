import SwiftUI

struct KazaManagementView: View {
    // ViewModel'i dışarıdan alıyoruz
    var viewModel: HistoryViewModel
    // Kapatma butonu için environment
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                // Tema arka planı
                AppTheme.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {

                        // Header Bilgisi
                        VStack(spacing: 8) {
                            Text("Namaz Kazalarım")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.primary)
                            Text("Eksik namazlarını buradan takip edebilirsin.")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)

                        // 6 Vakit Izgara Görünümü
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            kazaGridItem(title: "Sabah", icon: "🌅", prayerKey: "Sabah")
                            kazaGridItem(title: "Öğle", icon: "☀️", prayerKey: "Ogle")
                            kazaGridItem(title: "İkindi", icon: "🌤️", prayerKey: "Ikindi")
                            kazaGridItem(title: "Akşam", icon: "🌆", prayerKey: "Aksam")
                            kazaGridItem(title: "Yatsı", icon: "🌃", prayerKey: "Yatsi")
                            kazaGridItem(title: "Vitir", icon: "🌙", prayerKey: "Vitir")
                        }
                        .padding(.horizontal, 20)
                        
                        // Oruç Kazası Bölümü (Sadece borç varsa görünür)
                        if viewModel.kazaOrucTotal > 0 {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Oruç Kazalarım")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .padding(.horizontal, 4)
                                
                                kazaOrucRow()
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("Kaza Yönetimi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }
        }
    }

    // --- BİLEŞENLER ---

    private func kazaGridItem(title: String, icon: String, prayerKey: String) -> some View {
          // Vakit adına göre ViewModel'den doğru değerleri dinamik olarak çekiyoruz
          let total: Int
          let completed: Int
             
        switch prayerKey {
        case "Sabah": total = viewModel.kazaSabahTotal; completed = viewModel.kazaDebt?.sabahCompleted ?? 0
        case "Ogle": total = viewModel.kazaOgleTotal; completed = viewModel.kazaDebt?.ogleCompleted ?? 0
        case "Ikindi": total = viewModel.kazaIkindiTotal; completed = viewModel.kazaDebt?.ikindiCompleted ?? 0
        case "Aksam": total = viewModel.kazaAksamTotal; completed = viewModel.kazaDebt?.aksamCompleted ?? 0
        case "Yatsi": total = viewModel.kazaYatsiTotal; completed = viewModel.kazaDebt?.yatsiCompleted ?? 0
        case "Vitir": total = viewModel.kazaVitirTotal; completed = viewModel.kazaDebt?.vitirCompleted ?? 0
        default: total = 0; completed = 0
        }
         // Yeni animasyonlu kart bileşenimizi döndürüyoruz
        return KazaGridItemView(
            title: title,
            icon: icon,
            prayerKey: prayerKey,
            total: total,
            completed: completed,
            action: {
                viewModel.incrementKaza(for: prayerKey)
            }
        )


    }
       
        
    
    private func kazaOrucRow() -> some View {
        // Yeni animasyonlu oruç satırını döndürüyoruz
        KazaOrucRowView(
            total: viewModel.kazaOrucTotal,
            completed: viewModel.kazaOrucCompleted,
            action: {
                viewModel.incrementOruc()
            }
        )
       
    }
}
#Preview {
    KazaManagementView(viewModel: HistoryViewModel())
}
