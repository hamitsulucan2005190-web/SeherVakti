//
//  DhikrLog.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 27.04.2026.
//

import Foundation
import SwiftData
// @Model: Bu sınıfın her nesnesi veritabanında bir satır olarak saklanır
@Model
final class DhikrLog {
    // Her kayıt için benzersiz kimlik
       var id: UUID
       
       // Zikrin adı — Kullanıcının Zikirmatik'te yazdığı metin (örn: "Sübhanallah")
       var title: String
       
       // Zikir sırasında ulaşılan sayı (örn: 33)
       var count: Int
       
       // Kullanıcının belirlediği hedef sayı (örn: 33)
       var target: Int
       
       // Bu zikrin kaydedildiği tarih ve saat
       var date: Date
       
    // Başlangıç değerleri (default parametreler sayesinde date yazmak zorunda değiliz)
      init(title: String, count: Int, target: Int, date: Date = .now) {
          self.id = UUID()
          self.title = title
          self.count = count
          self.target = target
          self.date = date
      }
}
