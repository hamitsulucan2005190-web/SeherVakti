//
//  PrayerTimesView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 20.04.2026.
//

import SwiftUI
import SwiftData

struct PrayerTimesView: View {
    // ViewModel'imizi buraya da dahil ediyoruz (Verilere erişmek için)
    @State private var viewModel = DashboardViewModel()
    @Environment(\.modelContext) private var modelContext

    // Hangi namazların kılındığını takip eder (Set: tekrarsız liste)
    @State private var completedPrayers: Set<String> = []
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 26){
                    // Ekran Başlığı
                    Text("Namaz\nVakitleri")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.primary)
                                                .padding(.top, 20) // rengi ve konumu ayarlandı
                    
                    // 2. Vakit Listesi Konteynırı
                    VStack(spacing: 0) {
                        ForEach(viewModel.prayerTimes) { prayer in
                            VStack(spacing: 0) {
                                HStack {
                                    Text(prayer.name)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    
                                    Spacer()
                                    // kıldım butonu 
                                    Button(action: {
    // Bu namazı "tamamlandı" listesine ekle
    completedPrayers.insert(prayer.name)
    
    // ← BU SATIR BURAYA GİRİYOR (isCompleted: true ekli hali)
    let log = PrayerLog(prayerName: prayer.name, date: prayer.date, isCompleted: true)
    
    // SwiftData'ya kaydet
    modelContext.insert(log)
}) {
    // Kılındıysa yeşil tik, kılınmadıysa gri buton göster
    if completedPrayers.contains(prayer.name) {
        Image(systemName: "checkmark.circle.fill")
            .font(.title2)
            .foregroundColor(.green)
    } else {
        Text("Kıldım")
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundColor(AppTheme.Colors.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppTheme.Colors.primary.opacity(0.1))
            .clipShape(Capsule())
    }
}

                                    
                                    Text(prayer.date, style: .time)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .monospacedDigit() // Rakamların hizalı durması için
                                }
                                .padding(.vertical, 24)
                                .foregroundColor(prayer.isPassed ? .secondary : .primary)
                                
                                // Çizgisiz kuralı: Sadece en altta olmayanlar için çok silik bir ayraç
                                if prayer.name != viewModel.prayerTimes.last?.name {
                                    Divider()
                                        .background(Color.secondary.opacity(0.1))
                                }
                            }
                        }
                    }
                    .padding(.horizontal,20)
                    .background(AppTheme.Colors.surfaceLowest) // Beyaz kart efekti
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard)) // 24pt köşe
                    

                    
                }
                .padding(.horizontal, 20)
                            .padding(.bottom, 30)
            }
            .background(AppTheme.Colors.background.ignoresSafeArea())

        }
    }
}

#Preview {
    PrayerTimesView()
}
