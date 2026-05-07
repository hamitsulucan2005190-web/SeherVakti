//
//  KazaDebt.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 2.05.2026.
//

import Foundation
import SwiftData

// @Model: Bu sınıfın bir SwiftData veritabanı tablosu olacağını belirtir
@Model
final class KazaDebt {
    
    // --- NAMAZ BORÇLARI ---
        
        // Sabah namazı toplam borç ve tamamlanan sayısı
        var sabahTotal: Int = 0
        var sabahCompleted: Int = 0
        
       
        var ogleTotal: Int = 0
        var ogleCompleted: Int = 0
        
        
        var ikindiTotal: Int = 0
        var ikindiCompleted: Int = 0
        
        
        var aksamTotal: Int = 0
        var aksamCompleted: Int = 0
        
       
        var yatsiTotal: Int = 0
        var yatsiCompleted: Int = 0
        
       
        var vitirTotal: Int = 0
        var vitirCompleted: Int = 0
        
        // --- ORUÇ BORÇLARI ---
        
        
        var orucTotal: Int = 0
        var orucCompleted: Int = 0
        
        // Sınıf oluşturulduğunda varsayılan değerleri atar
        init(sabahTotal: Int = 0, ogleTotal: Int = 0, ikindiTotal: Int = 0, aksamTotal: Int = 0, yatsiTotal: Int = 0, vitirTotal: Int = 0, orucTotal: Int = 0) {
            self.sabahTotal = sabahTotal
            self.ogleTotal = ogleTotal
            self.ikindiTotal = ikindiTotal
            self.aksamTotal = aksamTotal
            self.yatsiTotal = yatsiTotal
            self.vitirTotal = vitirTotal
            self.orucTotal = orucTotal
        }
    
    
}
