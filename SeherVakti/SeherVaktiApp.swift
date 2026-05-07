//
//  SeherVaktiApp.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 12.04.2026.
//

import SwiftUI
import SwiftData

@main
struct SeherVaktiApp: App {
        // Hafızadaki durumu kontrol ediyoruz
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    // karanlık mod tercihini getiriyoruz
      @AppStorage("isDarkMode") private var isDarkMode: Bool = false



    // Veritabanı (SwiftData) konteynırı burada tanımlanıyor
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PrayerLog.self, //  yeni modelimizi buraya tanıttık
            Item.self,
            JournalEntry.self, // defter modelini tanıttık 
            DhikrLog.self,
            FocusLog.self,
            KazaDebt.self,
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // Akıllı Yönlendirme (Routing)
           Group {
            if hasSeenOnboarding {
                // Kullanıcı her şeyi onayladıysa, güvende! Ana menüye al.
                MainTableView()
            } else {
                // İlk defa geliyorsa Karşılama Serüvenini başlat!
                OnboardingView()
            }
            
            
        }
        // aydınlık mı karanlık mı modu belirler
          .preferredColorScheme(isDarkMode ? .dark : .light)
        }

        .modelContainer(sharedModelContainer)
    }
}
