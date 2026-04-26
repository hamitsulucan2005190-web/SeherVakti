//
//  NotificationStepView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 26.04.2026.
//

import SwiftUI

struct NotificationStepView: View {
    @Binding var currentStep: Int

    // Bildirim izni durumunu hafızaya kaydederiz
     @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    var body: some View {
        
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // --- Üst Navigasyon ve Sayfa İndikatörü ---
                HStack {
                    // Geri Tuşu
                    Button(action: {
                        withAnimation(.easeInOut) {
                            currentStep -= 1 // Geri git
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.Colors.primary)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.05), radius: 5)
                    }
                    
                    Spacer()
                    
                    // Sayfa İndikatörü ( . | . | - | . )
                    HStack(spacing: 8) {
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        Capsule().fill(AppTheme.Colors.primary).frame(width: 24, height: 4) // 3. Adım aktif
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                    }
                    .padding(.trailing, 40)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // --- Zil İkonu ---
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primary)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
                
                // --- Başlıklar ---
                VStack(spacing: 12) {
                    Text("Namazları kaçırma")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.primary)
                    
                    Text("Vakit girmeden önce seni haberdar edelim, huzurlu bir hazırlık için vaktin olsun.")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                // --- Örnek Bildirim Kartı (Mockup) ---
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(AppTheme.Colors.primary)
                            .font(.system(size: 12))
                        Text("AMEL DEFTERİ")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.primary.opacity(0.7))
                        Spacer()
                        Text("Şimdi")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 2)
                    
                    Text("Öğle namazına 15 dakika kaldı")
                        .font(.system(size: 15, weight: .bold))
                    
                    Text("Hazırlık yapmak için en güzel zaman.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Spacer()
                
                // --- Butonlar ---
                VStack(spacing: 16) {
                    // Bildirimlere İzin Ver Butonu
                    Button(action: {
                        // TODO: İleride burada iOS'ten izin isteme (Request Authorization) penceresini tetikleyeceğiz.
                        notificationsEnabled = true
                        withAnimation(.easeInOut) {
                            currentStep = 4 // Konum adımına geç
                        }
                    }) {
                        HStack {
                            Text("Bildirimlere İzin Ver")
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                        }
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: AppTheme.Colors.primary.opacity(0.3), radius: 10, y: 5)
                    }
                    
                    // Şimdi Değil Butonu (Atla)
                    Button(action: {
                        notificationsEnabled = false
                        withAnimation(.easeInOut) {
                            currentStep = 4
                        }
                    }) {
                        Text("Şimdi Değil")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
    }

    }


#Preview {
    NotificationStepView(currentStep: .constant(3))

}
