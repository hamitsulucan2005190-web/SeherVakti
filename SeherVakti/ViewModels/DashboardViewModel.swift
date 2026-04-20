//
//  DashboardViewModel.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 18.04.2026.
//

import Foundation

import Observation

// Dashboard ekranının tüm mantığını yöneten sınıf
@Observable
class DashboardViewModel {
    
    // Tüm namaz vakitlerini tutan liste
    var prayerTimes: [PrayerTime] = []
    
    var timeRemaining:String = "00:00:00" // sayaç
    
    // Timer referansını tutuyoruz
        private var timer: Timer?

    
    // Bir sonraki vaktin hangisi olduğunu bulan hesaplamalı özellik
    var nextPrayer: PrayerTime? {
        // Vakitler içinde saati şu andan ileri olan ilk vakti bulur
        return prayerTimes.first(where: { !$0.isPassed }) ?? prayerTimes.first
    }
    // Uygulama açık olduğu sürece her saniye çalışacak fonksiyon
     private func startTimer() {
         timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
             self.updateCountdown()
         }
     }
    
    // ViewModel oluşturulduğunda çalışacak başlangıç fonksiyonu
    init() {
        loadMockData()
        startTimer() // Başlangıçta timer'ı çalıştır
    }
    // Kalan süreyi hesaplayan asıl mantık
    private func updateCountdown() {
        guard let next = nextPrayer else { return }
        
        let diff = next.date.timeIntervalSince(Date())
        
        if diff > 0 {
            // Saniyeyi Saat:Dakika:Saniye formatına çevirir
            let hours = Int(diff) / 3600
            let minutes = Int(diff) % 3600 / 60
            let seconds = Int(diff) % 60
            timeRemaining = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            timeRemaining = "Vakit Geldi!"
        }
    }
    
    // Test amaçlı geçici veriler yükler (Gerçek API gelene kadar)
    private func loadMockData() {
        let calendar = Calendar.current
        let today = Date()
        
        // Örnek vakitler oluşturuyoruz
        prayerTimes = [
            PrayerTime(name: "İmsak", date: calendar.date(bySettingHour: 4, minute: 30, second: 0, of: today)!),
            PrayerTime(name: "Güneş", date: calendar.date(bySettingHour: 6, minute: 05, second: 0, of: today)!),
            PrayerTime(name: "Öğle", date: calendar.date(bySettingHour: 13, minute: 15, second: 0, of: today)!),
            PrayerTime(name: "İkindi", date: calendar.date(bySettingHour: 17, minute: 02, second: 0, of: today)!),
            PrayerTime(name: "Akşam", date: calendar.date(bySettingHour: 19, minute: 55, second: 0, of: today)!),
            PrayerTime(name: "Yatsı", date: calendar.date(bySettingHour: 21, minute: 30, second: 0, of: today)!)
        ]
    }
}

