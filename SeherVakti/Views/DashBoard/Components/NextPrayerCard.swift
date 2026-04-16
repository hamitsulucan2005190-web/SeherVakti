//
//  NextPrayerCard.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 14.04.2026.
//

import SwiftUI
// Bir sonraki namaz vaktini gösteren ana kart bileşeni
struct NextPrayerCard: View {
    var body: some View {
        ZStack {
            
            AppTheme.Colors.primary

        // Katman 2: Kartın İçindeki Yazılar
            VStack(spacing : 12){
                Text("Bir Sonraki Vakit")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                // Tasarım kuralı: %70 opaklık (Vurguyu azaltır)
                // Namazın İsmi: Büyük ve kalın (Editorial hissiyat)
                        Text("Akşam")
                                  .font(.system(size: 36, weight: .bold)) // Büyük ve dikkat çekici
                                  .foregroundColor(.white)
                        
                              // Geri Sayım Sayacı: Dökümanımızdaki "Rounded" (Yuvarlatılmış) font kuralı
                              Text("01:25:40")
                                  .font(.system(size: 44, weight: .semibold, design: .rounded)) // Yuvarlatılmış sayaç fontu
                                  .foregroundColor(.white)
            }
            
                
        }
        .cornerRadius(AppTheme.Radius.mainCard)
    // Kartın dışarıdan görünürlüğünü artırmak için sabit bir yükseklik ve iç boşluk veriyoruz
    
        .frame(height: 200)
        .padding(.horizontal)
    
    }
}

#Preview {
    NextPrayerCard()
}
