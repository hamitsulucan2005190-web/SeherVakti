//
//   JournalEntry.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 22.04.2026.
//

import Foundation
import SwiftData

// @Model makrosu, bu sınıfı direkt bir veritabanı tablosuna dönüştürür.
@Model
class JournalEntry {
    
    var id : UUID
    
    // Notun yazıldığı gün ve saat
       var date: Date
    
    // Kullanıcının yazdığı şükür/iyilik metni
       var content: String
       
       // İleride "Tövbe", "İyilik", "Dilek" gibi farklı defter tiplerine ayırt edebilmek için tip alanı
       var entryType: String
       
       // Yeni bir not oluşturulduğunda ilk tetiklenen fonksiyon (Constructor)
       init(content: String, entryType: String = "Şükür") {
           self.id = UUID()
           // O anki tarihi otomatik alır
           self.date = Date()
           self.content = content
           self.entryType = entryType
       }
    
    
}
