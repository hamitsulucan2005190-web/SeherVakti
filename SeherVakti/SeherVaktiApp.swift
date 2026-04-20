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
    // Veritabanı (SwiftData) konteynırı burada tanımlanıyor
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PrayerLog.self, //  yeni modelimizi buraya tanıttık
            Item.self,
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
            
            // YENİ: Uygulama artık bizim oluşturduğumuz sekmeli menü ile açılacak
            MainTableView()
        }
        .modelContainer(sharedModelContainer)
    }
}
