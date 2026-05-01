//
//  AladhanResponse.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 27.04.2026.
//

import Foundation

// API'den gelen ana kapsayıcı
struct AladhanResponse: Codable {
    let code: Int
    let status: String
    let data: PrayerDayData
}

// Günlük veri yapısı
struct PrayerDayData: Codable {
    let timings: Timings
    let date: DateData
    let meta: MetaData
}

// Namaz vakitleri (API'den gelen orijinal isimler)
struct Timings: Codable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
    
    // API isimlerini projedeki isimlendirme standartlarımıza (CamelCase) çeviriyoruz
    enum CodingKeys: String, CodingKey {
        case Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha
    }
}

// Tarih verisi (Gerekirse kullanılabilir)
struct DateData: Codable {
    let readable: String
    let timestamp: String
}

// Metadatalar (Hesaplama yöntemi vb.)
struct MetaData: Codable {
    let method: CalculationMethod
}

struct CalculationMethod: Codable {
    let id: Int
    let name: String
}
