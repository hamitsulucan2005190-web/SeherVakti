import Foundation
import Observation
import SwiftUI

@Observable
class DashboardViewModel {
    
    // Kullanıcı verileri (AppStorage'dan çekiliyor)
    private var userCity: String {
        UserDefaults.standard.string(forKey: "userCity") ?? "İstanbul"
    }
    
    var userName: String {
        UserDefaults.standard.string(forKey: "userName") ?? "Misafir"
    }
    
    // Veri Durumları
    var prayerTimes: [PrayerTime] = []
    var timeRemaining: String = "00:00:00"
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private var timer: Timer?

    // Sonraki vaktin hesaplanması
    var nextPrayer: PrayerTime? {
        let now = Date()
        return prayerTimes.first(where: { $0.date > now }) ?? prayerTimes.first
    }
    
    init() {
        Task {
            await fetchPrayerTimes()
        }
        startTimer()
    }
    
    // Gerçek Veri Çekme Fonksiyonu
    func fetchPrayerTimes() async {
        await MainActor.run { isLoading = true; errorMessage = nil }
        
        do {
            let timings = try await PrayerTimeService.shared.fetchDailyTimings(city: userCity)
            let parsed = parseTimings(timings)
            
            await MainActor.run {
                self.prayerTimes = parsed
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = "Vakitler yüklenemedi."
            }
        }
    }
    
    // Geri Sayım Mantığı
    private func updateCountdown() {
        guard let next = nextPrayer else { return }
        
        var nextDate = next.date
        if nextDate < Date() {
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: nextDate) ?? nextDate
        }
        
        let diff = nextDate.timeIntervalSince(Date())
        
        if diff > 0 {
            let hours = Int(diff) / 3600
            let minutes = Int(diff) % 3600 / 60
            let seconds = Int(diff) % 60
            timeRemaining = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            timeRemaining = "Vakit Geldi!"
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    // Saati Date formatına çeviren yardımcı fonksiyon
    private func parseTimings(_ timings: Timings) -> [PrayerTime] {
        let names = ["İmsak", "Güneş", "Öğle", "İkindi", "Akşam", "Yatsı"]
        let rawTimes = [timings.Fajr, timings.Sunrise, timings.Dhuhr, timings.Asr, timings.Maghrib, timings.Isha]
        
        var result: [PrayerTime] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        let now = Date()
        
        for (index, timeStr) in rawTimes.enumerated() {
            if let date = formatter.date(from: timeStr) {
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                let timeComponents = calendar.dateComponents([.hour, .minute], from: date)
                components.hour = timeComponents.hour
                components.minute = timeComponents.minute
                
                if let finalDate = calendar.date(from: components) {
                    result.append(PrayerTime(name: names[index], date: finalDate))
                }
            }
        }
        return result
    }
}
