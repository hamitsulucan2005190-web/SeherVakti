import Foundation
import Observation
import SwiftUI
import SwiftData  

// @Observable: View'ın bu sınıftaki değişiklikleri anlık takip etmesini sağlar
@Observable
class HistoryViewModel {

    static let shared = HistoryViewModel()

    // Veritabanı bağlantısını burada tutacağız
    var modelContext: ModelContext?
    
    // Veritabanındaki tek bir borç kaydını burada saklayacağız
    var kazaDebt: KazaDebt?



    // Vakit isimlerini tek bir yerde tutuyoruz 
    let prayerKeys = ["Sabah", "Ogle", "Ikindi", "Aksam", "Yatsi", "Vitir"]

    func setup(context: ModelContext) {
        self.modelContext = context
        
        // Veritabanında daha önce oluşturulmuş bir borç kaydı var mı diye bakıyoruz
        let descriptor = FetchDescriptor<KazaDebt>()
        
        if let existingDebt = try? context.fetch(descriptor).first {
            // Varsa, onu kullanıyoruz
            self.kazaDebt = existingDebt
        } else {
            // Eğer veritabanı boşsa, ilk defa bir borç nesnesi oluşturup kaydediyoruz
            let newDebt = KazaDebt()
            context.insert(newDebt)
            self.kazaDebt = newDebt
        }
    }
    



   

    // --- AYARLAR VE SENKRONİZASYON İÇİN BORÇ BAĞLANTILARI ---

        // --- AYARLAR VE SENKRONİZASYON (SwiftData Versiyonu) ---

    // Sabah Namazı Borcu
    var kazaSabahTotal: Int {
        get { kazaDebt?.sabahTotal ?? 0 }
        set { kazaDebt?.sabahTotal = newValue }
    }
    
    
    var kazaOgleTotal: Int {
        get { kazaDebt?.ogleTotal ?? 0 }
        set { kazaDebt?.ogleTotal = newValue }
    }
    
    
    var kazaIkindiTotal: Int {
        get { kazaDebt?.ikindiTotal ?? 0 }
        set { kazaDebt?.ikindiTotal = newValue }
    }
    
    
    var kazaAksamTotal: Int {
        get { kazaDebt?.aksamTotal ?? 0 }
        set { kazaDebt?.aksamTotal = newValue }
    }
    
    // Yatsı Namazı Borcu
    var kazaYatsiTotal: Int {
        get { kazaDebt?.yatsiTotal ?? 0 }
        set { kazaDebt?.yatsiTotal = newValue }
    }
    
    // Vitir Namazı Borcu
    var kazaVitirTotal: Int {
        get { kazaDebt?.vitirTotal ?? 0 }
        set { kazaDebt?.vitirTotal = newValue }
    }

    // Oruç Borcu Toplamı
    var kazaOrucTotal: Int {
        get { kazaDebt?.orucTotal ?? 0 }
        set { kazaDebt?.orucTotal = newValue }
    }
    
    // Oruç Tamamlanan Sayısı
    var kazaOrucCompleted: Int {
        get { kazaDebt?.orucCompleted ?? 0 }
        set { kazaDebt?.orucCompleted = newValue }
    }


    
    




    
    // --- TOPLAM HESAPLAMALAR ---
      // Tüm namaz borçlarının toplamını hesaplayan özellik (SwiftData üzerinden)
    var totalNamazDebt: Int {
        guard let debt = kazaDebt else { return 0 }
        return debt.sabahTotal + debt.ogleTotal + debt.ikindiTotal + debt.aksamTotal + debt.yatsiTotal + debt.vitirTotal
    }
    
    // Tamamlanan toplam namaz sayısını hesaplayan özellik (SwiftData üzerinden)
    var totalNamazCompleted: Int {
        guard let debt = kazaDebt else { return 0 }
        return debt.sabahCompleted + debt.ogleCompleted + debt.ikindiCompleted + debt.aksamCompleted + debt.yatsiCompleted + debt.vitirCompleted
    }
   
    
    // Toplam ilerleme yüzdesini hesaplama 
    var completionPercentage: Int {
        guard totalNamazDebt > 0 else { return 0 }
        // (Tamamlanan / Toplam) * 100 formülü
        return (totalNamazCompleted * 100) / totalNamazDebt
    }
    
      // Ekranda kaza kartı gösterilsin mi? (En az 1 borç girilmişse true döner)
    var hasAnyDebt: Bool {
        totalNamazDebt > 0 || (kazaDebt?.orucTotal ?? 0) > 0
    }
    
    // --- AKSİYONLAR (Business Logic) ---
    
   // Bir vaktin kaza sayısını 1 artırmak için kullanılan ana fonksiyon
    func incrementKaza(for prayerName: String) {
        guard let debt = kazaDebt else { return }
        
        // Gelen namaz ismine göre ilgili modeli güncelliyoruz
        switch prayerName {
        case "Sabah":
            if debt.sabahCompleted < debt.sabahTotal { debt.sabahCompleted += 1 }
        case "Ogle":
            if debt.ogleCompleted < debt.ogleTotal { debt.ogleCompleted += 1 }
        case "Ikindi":
            if debt.ikindiCompleted < debt.ikindiTotal { debt.ikindiCompleted += 1 }
        case "Aksam":
            if debt.aksamCompleted < debt.aksamTotal { debt.aksamCompleted += 1 }
        case "Yatsi":
            if debt.yatsiCompleted < debt.yatsiTotal { debt.yatsiCompleted += 1 }
        case "Vitir":
            if debt.vitirCompleted < debt.vitirTotal { debt.vitirCompleted += 1 }
        default:
            break
        }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred() // Dokunsal geri bildirim
    }
    // Oruç artırma fonksiyonu
    func incrementOruc() {
        if kazaOrucCompleted < kazaOrucTotal {
            kazaOrucCompleted += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    // --- İSTATİSTİKLER ---
    
    // Bugünün verilerini temsil eden küçük bir model
    struct TodayStats {
        var prayerCount: Int
        var focusMinutes: Int
        var dhikrCount: Int
    }
    
    // Bugünün istatistiklerini hesaplayan fonksiyon (View'dan hesap yükünü alır)
    func calculateTodayStats(prayerLogs: [PrayerLog], focusLogs: [FocusLog], dhikrLogs: [DhikrLog]) -> TodayStats {
        let startOfToday = Calendar.current.startOfDay(for: .now)
        
        let prayers = prayerLogs.filter { $0.date >= startOfToday }.count
        let focus = focusLogs.filter { $0.date >= startOfToday }.reduce(0) { $0 + $1.durationMinutes }
        let dhikr = dhikrLogs.filter { $0.date >= startOfToday }.reduce(0) { $0 + $1.count }
        
        return TodayStats(prayerCount: prayers, focusMinutes: focus, dhikrCount: dhikr)
    }
}

