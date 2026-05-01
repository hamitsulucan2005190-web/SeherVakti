//
//  FocusLog.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 27.04.2026.
//

import Foundation
import SwiftData


// @Model: Bu sınıfın her nesnesi SwiftData veritabanına kaydedilir
@Model
final class FocusLog {
    
    // Her kayıt için benzersiz kimlik
    var id: UUID
    
    // Odaklanma oturumunun başlığı (Kullanıcının verdiği isim — örn: "Kur'an Okuma")
    var title: String
    
    // Kaç dakika odaklanıldı (örn: 25, 45, 60)
    var durationMinutes: Int
    
    // Bu oturumun tamamlandığı tarih ve saat
    var date: Date
    // title parametresine default değer verdik → kullanıcı başlık girmezse "Odak Seansı" yazar
    init(title: String = "Odak Seansı", durationMinutes: Int, date: Date = .now) {
        self.id = UUID()
        self.title = title
        self.durationMinutes = durationMinutes
        self.date = date
    }
}
