//
//  KazaOrucRowView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 4.05.2026.
//

import SwiftUI

struct KazaOrucRowView: View {
    let total: Int
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
    
    private var isCompleted: Bool { completed >= total && total > 0 }
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.08, green: 0.09, blue: 0.12).opacity(0.6) : Color.white.opacity(0.6)
    }

    var body : some View {
         // İçerik önce render ediliyor, arka plan ona göre boyutlanıyor
    contentView
        .padding(16)
        .background(
            ZStack {
                // Katman 1: Buzlu cam efekti
                RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                // Katman 2: Tema rengini %25 şeffaflıkla üstüne ekliyoruz
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark
                          ? Color(red: 0.08, green: 0.09, blue: 0.14).opacity(0.25)
                          : Color.white.opacity(0.25))
            }
        )
        .overlay(
            // İnce bir çerçeve (ghost border) — Design System kuralı
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.05), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.08), radius: 12, x: 0, y: 6)

       
    }
    
    private var contentView: some View {
        HStack(spacing: 16) {
            Text("🌙")
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text("Kaza Orucu")
                    .font(.system(size: 16, weight: .bold, design: .rounded))

                if isCompleted {
                    Text("Tamamlandı ✅")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.green)
                        .scaleEffect(showCompletionCelebration ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: showCompletionCelebration)
                } else {
                    Text("\(completed)/\(total) Gün")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            ZStack {
                Button {
                    // Hafif bir dokunma hissi — "1 gün daha tutuldu"
    let impact = UIImpactFeedbackGenerator(style: .light)
    impact.impactOccurred()
                    action()
                    triggerFloatingAnimation()
                    if completed + 1 == total { triggerCelebration() }
                } label: {
                    Text("+1 Tuttum")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isCompleted ? Color.gray : Color.indigo)
                        .clipShape(Capsule())
                }
                .disabled(isCompleted || total == 0)

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
    
    private func triggerFloatingAnimation() {
        showFloatingPlusOne = true
        floatingOffset = 0
        floatingOpacity = 1.0
        
        withAnimation(.easeOut(duration: 0.6)) {
            floatingOffset = -40 // Yukarı süzül
            floatingOpacity = 0  // Kaybol
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showFloatingPlusOne = false
        }
    }
    
    private func triggerCelebration() {
        showCompletionCelebration = true
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showCompletionCelebration = false
        }
    }
}

#Preview {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        
        KazaOrucRowView(
            total: 60,
            completed: 10,
            action: {
                print("Oruç butonuna tıklandı!")
            }
        )
        .padding()
    }
}
