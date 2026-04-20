//
//  NextPrayerCard.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 14.04.2026.
//

import SwiftUI
// Bir sonraki namaz vaktini gösteren ana kart bileşeni
struct NextPrayerCard: View {
    
    let prayer : PrayerTime? // gelecek namaz vakti
    let countDown :String // geri sayım
    var body: some View {
        ZStack {
            
            // arka planı yumuşak bir gradyan eklemek için
            
            LinearGradient(gradient: Gradient(colors: [AppTheme.Colors.primary,
                                                       AppTheme.Colors.primary.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            
            // Katman 2: Kartın İçindeki Yazılar
            VStack(spacing : 8){
                Text(prayer?.name.uppercased() ?? "YÜKLENİYOR")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .kerning(2)
                
                
                    .foregroundColor(.white)
                
                // Tasarım kuralı: %70 opaklık (Vurguyu azaltır)
                // Namazın İsmi: Büyük ve kalın (Editorial hissiyat)
                
                
                Text(countDown)
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "clock.fill")
                    Text("Sıradaki Vakte Kalan Süre")
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, 30)
        }
        
        
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard)) // 24pt köşe kuralı
        // 3. Ambient Shadow (Tasarım kuralı: Yumuşak gölge)
        .shadow(color: AppTheme.Colors.primary.opacity(0.3), radius: 20, x: 0, y: 10)
    
                
        
        .cornerRadius(AppTheme.Radius.mainCard)
    // Kartın dışarıdan görünürlüğünü artırmak için sabit bir yükseklik ve iç boşluk veriyoruz
    
        .frame(height: 200)
        
    
    }
}

#Preview {
    NextPrayerCard(prayer: nil,countDown: "00:00:00")
}
