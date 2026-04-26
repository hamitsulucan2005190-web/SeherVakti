//
//  FocusViewModel.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 21.04.2026.
//
//


import SwiftUI
import Combine
import Observation

// View'da değişiklik olduğunda arayüzü güncellemesi için Observable(UI güncelleyici) kullanıyoruz
@Observable
class FocusViewModel {
    //  Sayfada hangi bölümde olduğumuzu belirleyen özel tip (Enum)
       enum FocusMode {
           case focus  // Odaklanma (Pomodoro/Ders vb.) modu
           case dhikr  // Sadece Zikir çekme modu
       }
   //    Uygulama açıldığında varsayılan olarak "Odak" modu seçili gelsin
        var currentMode: FocusMode = .focus
    
    // Zikir sayacı değişkeni
    var dhikrCount: Int = 0
    
    // Zikir Başlığı (kullanıcı değiştirebilecek)

    var dhikrTitle: String = "Allahümme Salli Ala Seyyidina Muhammedin Ve Ala Ali Muhammed"

    // zikir hedefi
    var dhikrTarget: Int = 33

    // zikir halkasının ne kadar dolduğunu gösteren değişken

    var dhikrProgress: Double {
        if dhikrTarget == 0 { return 0.0 }
        let progress = Double(dhikrCount) / Double(dhikrTarget)
        return min(progress, 1.0) // çemberin taşmaması için 
        
    }


    
    // YENİ: Kullanıcının seçtiği dakika (Varsayılan 25)
    var selectedMinutes: Int = 25 {
        didSet {
            // Kullanıcı dakikayı her değiştirdiğinde saniyeye çevirip süreyi güncelleriz
            totalFocusTime = TimeInterval(selectedMinutes * 60)
            timeRemaining = totalFocusTime
        }
    }
    
    // Toplam odaklanma süresi (Artık sabit değil, değişkene bağlı)
    var totalFocusTime: TimeInterval = 1500
    
    // Kalan zaman
    var timeRemaining: TimeInterval = 1500
    
    // Sayaç aktif mi?
    var isRunning: Bool = false
    
    // Timer objesini tuttuğumuz değişken
    private var timer: Timer?
    
    // Progress bar için oran hesaplama (0.0 ile 1.0 arası)
    var progress: Double {
        // İlerleme yüzdesini hesaplıyoruz
        return 1.0 - (timeRemaining / totalFocusTime)
    }
    
    // Ekranda göstereceğimiz formatlanmış zaman metni (Örn: "24:59")
    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Odaklanmayı başlatma fonksiyonu
    func startFocus() {
        isRunning = true
        // Her 1 saniyede bir çalışacak zamanlayıcıyı başlatıyoruz
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    // Odaklanmayı bitirme/durdurma fonksiyonu
    func stopFocus() {
        isRunning = false
        // Timer'ı durdurup temizliyoruz
        timer?.invalidate()
        timer = nil
    }
    // odaklanmayı sıfırlama butonu
    func resetFocusTimer(){
        stopFocus()
        timeRemaining = totalFocusTime // sayacı hedefe eşitliyoruz
        
    }
    
    // Saniyede bir tetiklenen fonksiyon
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            // Süre bittiğinde durdur
            stopFocus()
        }
    }
    
    // Zikir artırma butonu tetikleyicisi
    func incrementDhikr() {
        dhikrCount += 1
        
        // Haptik (Titreşim) ekleme
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    // Zikir sayacını sıfırlayan fonksiyon
    func resetDhikr() {
        dhikrCount = 0
    }

    
    
}




