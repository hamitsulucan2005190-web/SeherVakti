//
//  PrayerLog.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 18.04.2026.
//


import Foundation
import SwiftData

// @Model makrosu, bu sınıfın veritabanına kaydedileceğini belirtir
@Model
final class PrayerLog {
    // Benzersiz kimlik
    var id: UUID
    
    // Namazın adı (Örn: "Öğle")
    var prayerName: String
    
    // Kayıt tarihi
    var date: Date
    
    // Kılındı mı? 
    var isCompleted: Bool
    
    init(prayerName: String, date: Date = Date(), isCompleted: Bool = false) {
        self.id = UUID()
        self.prayerName = prayerName
        self.date = date
        self.isCompleted = isCompleted
    }
}



