//
//  PrayerTime.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 18.04.2026.
//

import Foundation

// Her bir namaz vaktini temsil eden veri yapımız
struct PrayerTime: Identifiable {
    // Benzersiz kimlik (SwiftUI listelerinde performans için gerekli)
    let id = UUID()
    
    // Vaktin ismi (Örn: "İmsak", "Güneş", "Öğle" vb.)
    let name: String
    
    // Vaktin tam saati
    let date: Date
    
    // Vaktin geçtiğini mi yoksa gelecek vakit mi olduğunu kontrol eder
    var isPassed: Bool {
        return date < Date()
    }
}

