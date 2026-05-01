# 📖 SeherVakti — Uygulama Planı (v3 · UX Revizyonu)

> **Hedef:** Kullanıcının ibadet hayatını kayıt altına alması, motive olması ve geçmişini takip etmesi.

---

## ✅ TAMAMLANANLAR

| Adım | Açıklama |
|------|----------|
| ✅ 1 | `DhikrLog.swift` + `FocusLog.swift` SwiftData modelleri |
| ✅ 2 | `SeherVaktiApp.swift` ModelContainer güncellemesi |
| ✅ 3 | `FocusViewModel` → `saveFocusLog()` + `saveDhikrLog()` |
| ✅ 3b | `FocusView` → Oturum kategorisi seçimi (Kur'an, İlim, Tefekkür, Özel) |
| ✅ 3c | `FocusView` → "Bugünkü Oturumlar" bölümü |
| ✅ 4 | `PrayerTimesView` → "Kıldım ✓" butonu + PrayerLog kaydı |
| ✅ 5 | `HistoryView.swift` oluşturuldu (Takip sekmesi) |
| ✅ 6 | `MainTableView` → "Vakitler" sekmesi → "Takip" sekmesine dönüştürüldü |

---

## 🚧 YAPILACAKLAR

### 🅰️ Öncelik 1 — Dashboard Yeniden Tasarımı

**Karar:** Dashboard ibadet detay listesi kaldırılıyor.
Takip sekmesi bu işi yapıyor. Dashboard → motivasyon + anlık durum.

**Yeni Dashboard Yapısı:**
```
┌─────────────────────────────────┐
│  Hicri Tarih · Pzt 30 Nisan     │  ← Dinamik tarih (Hicri + Miladi)
│  Hayırlı Günler, Hamit 🌙       │
│                                 │
│  🔥 5 Günlük Seri!              │  ← Streak sayacı (YENİ)
│                                 │
│  ┌─────────────────────────┐   │
│  │ SIRADAKİ VAKİT          │   │  ← API'den gerçek veri (mevcut)
│  │ Akşam — 01:14:22        │   │
│  └─────────────────────────┘   │
│                                 │
│  [✓Sabah] [✓Öğle] [İkindi] ... │  ← Namaz çipleri (mevcut)
│                                 │
│  💫 Günün Sözü                  │  ← Hadis kartı (YENİ)
│  "İki günü eşit olan            │
│   ziyandadır."                  │
│   — Hz. Muhammed (s.a.v)        │
└─────────────────────────────────┘
```

**Yapılacaklar:**
- [ ] `DashboardView` → Statik tarih → dinamik `Date.now.formatted()` ✏️
- [ ] `DashboardView` → Streak sayacı bileşeni ekle
- [ ] `DashboardView` → Günlük Hadis Kartı ekle (sabit 3 hadis döngüsü)
- [ ] `DashboardView` → İbadet özet kartı kaldırılacak (Takip sekmesi var)

---

### 🅱️ Öncelik 2 — Takip Sekmesi Geliştirme

**Yeni Takip Sekmesi Yapısı:**
```
┌─────────────────────────────────┐
│  İBADET TAKİBİ                  │
│                                 │
│  ┌─── KAZA BORÇ TAKİBİ ──────┐ │  ← YENİ BÖLÜM
│  │ 🕌 Kaza Namazı             │ │
│  │ ████████░░░░  45/120 vakit │ │
│  │ [+ Bugün Kaza Kıldım]      │ │
│  │                             │ │
│  │ 🌙 Kaza Orucu              │ │
│  │ ██░░░░░░░░░░  3/15 gün     │ │
│  │ [+ Bugün Kaza Orucunu Tut] │ │
│  └─────────────────────────────┘ │
│                                 │
│  [Tümü] [Namaz] [Odak] [Zikir] │  ← Filtre (mevcut)
│                                 │
│  🕌 Sabah Namazı   06:12  ✓   │  ← Liste (mevcut)
│  🧠 Kur'an Okuma  25dk    ✓   │
│  📿 Sübhanallah   33x     ✓   │
└─────────────────────────────────┘
```

**Yapılacaklar:**
- [ ] `HistoryView` → Kaza Namazı ilerleme kartı ekle
- [ ] `HistoryView` → Kaza Orucu ilerleme kartı ekle
- [ ] `SettingsView` → "Kaza Borcu Ayarla" bölümü ekle (başlangıç sayısını girer)
- [ ] `HistoryView` → Günlük kaza sayacı artırma butonu

---

### 🅲 Öncelik 3 — Odak Seansı Success Screen

Timer sıfırlandığında motivasyon anı kaçırılıyor. Düzeltme:
- [ ] `FocusView` → Timer bitince `sheet` aç: "Maşallah! X dakika odaklandın 🎉"
- [ ] Success sheet → rastgele hadis göster
- [ ] Success sheet → "Kaydet" ve "Vazgeç" butonu

---

### 🅳 Öncelik 4 — Bildirim Sistemi (TODO.md Madde 4)

- [ ] `UNUserNotificationCenter` ile bildirim izni al
- [ ] Namaz vakti bildirimi zamanlama
- [ ] Ayarlar → "Namaz Bildirimleri" toggle ile kontrol

---

### 🅴 Öncelik 5 — Gerçek Namaz API (TODO.md Madde 3)

- [ ] Aladhan API bağlantısı doğrulama ve hata yönetimi
- [ ] Şehre göre gerçek vakitler
- [ ] Geri sayım gerçek zamanlı çalışıyor mu? Test et

---

## 🕌 Kaza Takip Sistemi — Mimari Kararı

### Neden AppStorage? (SwiftData değil)

Kaza borcu bir **liste değil, sayı**:
- "150 vakit kaza namazım var" → tek bir Int
- "15 gün kaza orucum var" → tek bir Int

SwiftData satır satır kayıt içindir. Tek sayı için `@AppStorage` çok daha temiz.

### Veri Modeli (AppStorage)

```swift
// Ayarlar ekranında kullanıcının girdiği borç miktarı
@AppStorage("kazaNamazTotal")     var kazaNamazTotal: Int = 0
@AppStorage("kazaNamazCompleted") var kazaNamazCompleted: Int = 0

@AppStorage("kazaOrucTotal")      var kazaOrucTotal: Int = 0
@AppStorage("kazaOrucCompleted")  var kazaOrucCompleted: Int = 0

// Kalan borç hesabı (computed):
var kazaNamazRemaining: Int { kazaNamazTotal - kazaNamazCompleted }
var kazaOrucRemaining: Int  { kazaOrucTotal  - kazaOrucCompleted  }
```

### Kullanıcı Akışı

```
Ayarlar → "Kaza Borcu" bölümü:
  → Kaza Namazı: [120] vakit (kullanıcı girer, 5 vakit = 1 gün)
  → Kaza Orucu:  [15]  gün   (kullanıcı girer)

Takip sekmesi:
  → İlerleme çubuğu: "45/120 vakit kaza kıldın"
  → [+ Bugün Kaza Kıldım] → her basışta +1 (veya +5 = 1 günlük kaza)
```

### Fıkhi Not

> 🕌 Kaza kaydı tamamen kullanıcı onaylıdır — otomatik kaza sayma yapılmaz.
> Kullanıcı kaç vakit kaza namazının olduğunu kendisi bilir ve girer.
> Bu fıkhi açıdan doğru ve güvenli yaklaşımdır.

---

## 💫 Hadis Havuzu (Dashboard + Odak)

Sabit bir liste — API gerekmez, internet bağlantısı gerektirmez:

```swift
let hadiths = [
    ("İki günü eşit olan ziyandadır.", "Hz. Muhammed (s.a.v)"),
    ("Amellerin en hayırlısı az da olsa devamlı olandır.", "Hz. Muhammed (s.a.v)"),
    ("Dili Allah'ı anmakla ıslak olan kişiye müjdeler olsun.", "Hz. Muhammed (s.a.v)"),
]
// Günün hadisini göstermek için: Calendar.current.dayOfYear % hadiths.count
```

---

## 🎓 Öğrenilecek Swift Konuları

| Konu | Nerede? |
|------|---------|
| `@AppStorage` ile sayaç yönetimi | Kaza Takip Sistemi |
| `@Query` ile bugün filtresi | FocusView, DashboardView |
| `sheet` ile success ekranı | FocusView timer bitişi |
| `Timer` + computed property | Streak hesabı |
| `reduce()` ile toplam | Dashboard istatistikleri |

---

## 🛣️ Güncel Uygulama Sırası

1. ✅ Model Temeli tamamlandı
2. ✅ FocusView tamamlandı
3. ✅ PrayerTimesView "Kıldım" butonu tamamlandı
4. ✅ HistoryView + MainTableView "Takip" sekmesi tamamlandı
5. → **Şu An:** Dashboard yeniden tasarımı (Streak + Hadis kartı)
6. → **Sonra:** SettingsView + HistoryView Kaza Takip Sistemi
7. → **Sonra:** FocusView Success Screen
8. → **Sonra:** Bildirim Sistemi
9. → **Sonra:** Gerçek Namaz API doğrulama
