//
//  KazaGridItemView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 4.05.2026.
//

import SwiftUI

struct KazaGridItemView: View {
    let title : String
    let icon : String
    let prayerKey : String
    let total : Int
    let completed: Int
    let action: () -> Void

     // Mikro-etkileşim (Micro-interaction) State'leri
    @State private var showFloatingPlusOne = false
    @State private var floatingOffset: CGFloat = 0
    @State private var floatingOpacity: Double = 0

    // Kutlama State'i
    @State private var showCompletionCelebration = false
    
    // Tema (Karanlık/Aydınlık) State'i
    @Environment(\.colorScheme) var colorScheme
    
    // Yardımcı Computed Property'ler
    private var isCompleted: Bool { completed >= total && total > 0 }
    
    // Karanlık modda lacivert/füme, aydınlık modda beyaz — ikisi de %25 şeffaf
// Bu sayede ultraThinMaterial'ın blur efekti öne çıkar
private var cardBackgroundColor: Color {
    colorScheme == .dark
        ? Color(red: 0.08, green: 0.09, blue: 0.14).opacity(0.25)
        : Color.white.opacity(0.25)
}
    
    private var cardStrokeColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.05)
    }
    
    private var cardShadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.08)
    }
    // Her vakit için o anın psikolojisini yansıtan bir vurgu rengi

private var prayerAccentColor: Color {
    switch prayerKey {
    case "Sabah":  return Color(red: 0.99, green: 0.85, blue: 0.50) // Gün doğumu sarısı
    case "Ogle":   return Color(red: 0.11, green: 0.49, blue: 0.33) // Design System primary
    case "Ikindi": return Color(red: 0.26, green: 0.60, blue: 0.59) // Design System secondary
    case "Aksam":  return Color(red: 0.88, green: 0.50, blue: 0.28) // Akşam turuncusu
    case "Yatsi":  return Color(red: 0.28, green: 0.30, blue: 0.65) // Gece laciverdı
    case "Vitir":  return Color(red: 0.52, green: 0.30, blue: 0.70) // Mor/menekşe
    default:       return AppTheme.Colors.primary
    }
}
    
    var body: some View {
        mainContent
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 16).fill(cardBackgroundColor)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16).stroke(cardStrokeColor, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: cardShadowColor, radius: 12, x: 0, y: 6)
    }
    
    private var mainContent: some View {
        VStack(spacing: 12) {
            HStack {
                Text(icon)
                Text(title).font(.system(size: 15, weight: .bold, design: .rounded))
            }
           .foregroundColor(prayerAccentColor)
            
            VStack(spacing: 4) {
                if isCompleted {
                    // Tamamlanma yazısı ve küçük pop-up efekti
                    Text("Tamamlandı ✅")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.green)
                        .scaleEffect(showCompletionCelebration ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: showCompletionCelebration)
                } else {
                    // .monospacedDigit() sayesinde rakam genişliği sabit kalır, yazı titremez
                    Text("\(completed)/\(total) Borç")
    .font(.system(size: 13, weight: .semibold).monospacedDigit())
    .foregroundColor(.secondary)
    .contentTransition(.numericText())
    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: completed)



                }
            }
            
            ZStack {
                

                // Ana Buton
                Button {
                    // Hafif bir dokunma hissi — kullanıcıya "kayıt edildi" mesajı verir
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()

                    // 1. İşlemi (ViewModel) çalıştır
                    action()
                    // 2. Yukarı süzülen +1 animasyonunu tetikle
                    triggerFloatingAnimation()
                    // 3. Eğer bu basışla borç bitiyorsa kutlama tetikle
                    if completed + 1 == total {
                        triggerCelebration()
                    }
                } label: {
                    Text("+1 Kıldım")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(isCompleted ? Color.gray.opacity(0.5):prayerAccentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(isCompleted || total == 0)
                
                // Yüzen +1 Animasyonu
                if showFloatingPlusOne {
                    Text("+1")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                        .offset(y: floatingOffset)
                        .opacity(floatingOpacity)
                }
            }
        }
    }
    
    // Yüzen animasyon fonksiyonu
    private func triggerFloatingAnimation() {
        showFloatingPlusOne = true
        floatingOffset = 0
        floatingOpacity = 1.0
        
        withAnimation(.easeOut(duration: 0.6)) {
            floatingOffset = -40 // 40 pixel yukarı süzül
            floatingOpacity = 0  // Görünmez ol
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showFloatingPlusOne = false
        }
    }
    
    // Tamamlanma kutlama fonksiyonu
    private func triggerCelebration() {
        showCompletionCelebration = true
        
        // Haptic feedback (Titreşim) ile dopamin etkisi
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showCompletionCelebration = false
        }
    }
}

#Preview {
     // Burada "Mock" (Sahte) veri vererek tasarımımızı test ediyoruz.
    ZStack {
        AppTheme.Colors.background.ignoresSafeArea() // Arka plan temasını görmek için
        
        KazaGridItemView(
            title: "Sabah",
            icon: "🌅",
            prayerKey: "Sabah",
            total: 150,
            completed: 45,
            action: {
                print("Sabah namazı butonuna tıklandı!") // Gerçek action yerine konsola yazdırıyoruz
            }
        )
        .padding() // Ekrana yapışmasın diye biraz boşluk bırakıyoruz
    }
}
