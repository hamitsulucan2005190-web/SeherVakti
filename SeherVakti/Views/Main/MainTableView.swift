//
//  MainTableView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 14.04.2026.
//

import SwiftUI


// Uygulamanın ana navigasyon yapısını (Sekmeli Menü) yöneten View
struct MainTableView: View {
    
    // Kullanıcının hangi sekmede olduğunu takip eden durum değişkeni
    @State private var selectedTab: Int = 0
    
    var body: some View {
        
        // Alt kısımdaki sekmeli menü yapısını oluşturur
        TabView(selection: $selectedTab){
            
            // 1. Sekme: Ana Sayfa
                      DashboardView() //  Yazı yerine DashboardView sayfamızı koyduk
                          .tabItem{
                              Label("Ana Sayfa", systemImage: "house.fill")
                          }
                          .tag(0) // sekmenin kimlik numarası
            
            // 2. Sekme: Namaz Vakitleri
            PrayerTimesView()
                .tabItem {
                    Label("Vakitler", systemImage: "clock.fill")
                        }
                .tag(1)
            
            // 3. Sekme: İyilik Defteri
                       Text("İyilik Defteri Ekranı")
                           .tabItem {
                               Label("Defter", systemImage: "book.fill")
                           }
                           .tag(2)
            
            // 4. Sekme: Ayarlar
                        Text("Ayarlar Ekranı")
                            .tabItem {
                                Label("Ayarlar", systemImage: "gearshape.fill")
                            }
                            .tag(3)
            
            
            
        }
        .accentColor(AppTheme.Colors.primary)
       
    }
}

#Preview {
    MainTableView()
}
