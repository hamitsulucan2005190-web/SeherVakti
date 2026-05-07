# 📖 SeherVakti — Uygulama Planı (v3 · UX Revizyonu)

> **Hedef:** Kullanıcının ibadet hayatını kayıt altına alması, motive olması ve geçmişini takip etmesi.



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



```

### Kullanıcı Akışı

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


---


