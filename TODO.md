# Seher Vakti - Ürün Yol Haritası (Görev Listesi)

## 📌 Tamamlanan Görevler (Phase 1: UI & Architecture)
- [x] MVVM Mimari Kurgusunun Kurulması
- [x] AppTheme (Tasarım Sistemi - The Digital Sanctuary) Entegrasyonu
- [x] TabView (Sekmeli Menü) Altyapısının Kurulması
- [x] Ana Sayfa (Dashboard) Tasarımı ve Bileşenleri
- [x] Namaz Vakitleri (PrayerTimes) Premium Arayüzü
- [x] İyilik Defteri (Journal) Özel Arayüzü
- [x] İyilik Defteri SwiftData Tamamlandı (Veri Ekleme, Listeleme, Sola Kaydırarak Silme)
- [x] Odaklanma / Zikirmatik Ekranı (Animasyonlar ve Temel Sayaç)
- [x] Ayarlar (Settings) Mükemmelleştirilmiş Şık Custom Tasarım

## 🚧 Yapılacaklar Listesi (Phase 2: Core Logic & Data Flow)

### 1. Karşılama Ekranı (Onboarding) ve Veri Hafızası
- [ ] Uygulama ilk kez açıldığında gösterilecek "Karşılama" (Onboarding) ekranını tasarlamak.
- [ ] Kullanıcıdan İsim bilgisini almak ve `@AppStorage` ile cihaza kaydetmek.
- [ ] Kullanıcıdan Şehir / Konum bilgisini almak.
- [ ] Ayarlar (Settings) ve Ana Sayfa'daki (Dashboard) statik ("AD, Amel Defteri", "İstanbul") yazıların dinamik olarak kullanıcı verisiyle eşleştirilmesi.

### 2. Tema Motoru (Dark/Light Mode)
- [ ] Ayarlar ekranındaki "Karanlık Mod" geçiş butonuna (Toggle) işlevsellik kazandırmak.
- [ ] `preferredColorScheme` kullanılarak uygulamanın rengini anında ayarlarla eşitlemek.

### 3. Gerçek Namaz Vakitleri Algoritması (API / Framework)
- [ ] Namaz Vakitleri için lokal bir kütüphane (Adhan Swift) veya direkt Diyanet web servisi bağlantısı kurmak.
- [ ] Ayarlardaki şehre (veya GPS verisine) dayanarak gerçek namaz saatleri matematiğini yapmak.
- [ ] Anasayfadaki "Sıradaki Vakte Kalan Süre" bileşenini gerçek zamanlı çalışır duruma getirmek.

### 4. Bildirim Sistemi (Local Notifications)
- [ ] iOS UNUserNotificationCenter üzerinden uygulamaya girerken bildirim izni (Popup) listesi eklemek.
- [ ] Yeni bir namaz vakti girdiğinde veya X dakika öncesinde lokal bildirim (hatırlatıcı) göndermek üzere zamanlamak.
- [ ] Ayarlardaki "Namaz Bildirimleri" toggle butonu ile sesli/sessiz yönetimi yapmak.

---

*Not: Tüm testler ve özellik eklemeleri, SeherVakti .cursorrules standartlarında (MVVM & Clean Code) devam edecektir.*
