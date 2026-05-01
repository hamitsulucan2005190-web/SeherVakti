//
//  PrayerTime.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 18.04.2026.
//

import Foundation

struct PrayerTime: Identifiable, Codable {
    var id = UUID()
    let name: String
    let date: Date
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var isPassed: Bool {
        return date < Date()
    }
    
    var isNext: Bool {
        // ViewModel'deki nextPrayer ile aynı mı kontrolü
        return false // (Bu opsiyoneldir)
    }
}


