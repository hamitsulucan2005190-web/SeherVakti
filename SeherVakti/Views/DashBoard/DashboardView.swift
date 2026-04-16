//
//  DashboardView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 14.04.2026.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        // Ekranın kaydırılabilir olması için ScrollView kullanıyoruz
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                headerSection
            
                // Üst Başlık Bölümü (Header) - geçici yer tutucu
              

                Spacer(minLength: 0)
                
                NextPrayerCard()
            }
            .padding(.horizontal, 20) // Sayfanın her iki yanından iç boşluk veriyoruz
            .padding(.top, 40)
        }
        // Tasarımdaki yumuşak arka plan rengimizi uyguluyoruz
        .background(AppTheme.Colors.background.ignoresSafeArea())
    }
}
private var headerSection : some View {
    VStack(alignment: .leading, spacing: 8){
        // Bugünün Tarihi - Küçük ve gri tonlarda
                   Text("14 Nisan 2026")
                       .font(.subheadline)
                       .foregroundColor(.secondary)
        
        // Büyük ve asimetrik karşılama başlığı
                    Text("Hayırlı Sabahlar,\nSelamün Aleyküm")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        // Tasarımdaki koyu metin rengimizi kullanıyoruz
                        .foregroundColor(Color("#1a1c1f"))
                   
    }
    
}

#Preview {
    DashboardView()
}
