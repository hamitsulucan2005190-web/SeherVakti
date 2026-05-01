# Seher Vakti — Ürün Yol Haritası (Görev Listesi)

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

## 📌 Tamamlanan Görevler (Phase 2: Core Logic & Data Flow)
- [x] Onboarding ekranı (İsim + Şehir girişi, AppStorage)
- [x] Dark / Light Mode Tema Motoru
- [x] DhikrLog + FocusLog SwiftData modelleri
- [x] SeherVaktiApp ModelContainer güncellemesi
- [x] FocusViewModel — saveFocusLog() + saveDhikrLog()
- [x] FocusView — Oturum kategorisi seçimi (Kur'an, İlim, Tefekkür, Özel)
- [x] FocusView — "Bugünkü Oturumlar" bölümü
- [x] PrayerTimesView — "Kıldım ✓" butonu + PrayerLog kaydı
- [x] HistoryView (Takip sekmesi) — temel liste + özet kart
- [x] MainTableView — "Vakitler" → "Takip" sekmesine dönüştürüldü

---

## 🚧 Yapılacaklar Listesi (Phase 3: Motivasyon & Takip)

### 1. Dashboard Yeniden Tasarımı
- [ ] Dinamik tarih (Date.now.formatted ile Miladi tarih)
- [ ] Streak (ardışık gün) sayacı bileşeni
- [ ] Günlük Hadis Kartı (3 hadis döngüsü, internet gerektirmez)
- [ ] Dashboard ibadet özet kartını kaldır (Takip sekmesi var)

### 2. Kaza Borcu Takip Sistemi
- [ ] SettingsView → "Kaza Borcu" bölümü (kullanıcı toplam vakit/gün girer)
- [ ] AppStorage ile kaza sayaçları: kazaNamazTotal, kazaNamazCompleted, kazaOrucTotal, kazaOrucCompleted
- [ ] HistoryView → Kaza Namazı ilerleme çubuğu kartı
- [ ] HistoryView → Kaza Orucu ilerleme çubuğu kartı
- [ ] HistoryView → "Bugün Kaza Kıldım" butonu (sayacı artırır)

### 3. Odak Seansı Success Screen
- [ ] FocusView — Timer bitince sheet açılır
- [ ] Success screen — "Maşallah! X dakika odaklandın 🎉"
- [ ] Success screen — rastgele hadis göster
- [ ] Success screen — "Kaydet" / "Vazgeç" butonu

### 4. Gerçek Namaz Vakitleri API
- [ ] Aladhan API bağlantısı test et ve hata yönetimi ekle
- [ ] Ayarlardaki şehre göre gerçek vakitler
- [ ] Geri sayım gerçek zamanlı çalışıyor mu? Doğrula

### 5. Bildirim Sistemi
- [ ] UNUserNotificationCenter ile bildirim izni al
- [ ] Namaz vakti bildirimi zamanlama
- [ ] Ayarlar → "Namaz Bildirimleri" toggle ile yönetim

---

*Not: Tüm testler ve özellik eklemeleri, SeherVakti .cursorrules standartlarında (MVVM & Clean Code) devam edecektir.*
