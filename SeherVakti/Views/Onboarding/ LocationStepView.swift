//
//   LocationStepView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 26.04.2026.
//

import SwiftUI

struct _LocationStepView: View {
    @Binding var currentStep: Int
        
        // Uygulama ayarlarında şehri tutmak için
        @AppStorage("userCity") private var userCity: String = ""
        
        // Onboarding'i tamamen bitirmek için kalıcı hafıza değiştiricisi
        @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
        
    var body: some View {
        
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // --- Üst Navigasyon ve Sayfa İndikatörü ---
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            currentStep -= 1
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
                    
                    // Sayfa İndikatörü ( . | . | . | - )
                    HStack(spacing: 8) {
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        Capsule().fill(AppTheme.Colors.tertiary).frame(width: 24, height: 4) // Onay/Bitiş rengi Kehribar (Amber)
                    }
                    .padding(.trailing, 40)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // --- Konum İkonu ---
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                    
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 36))
                        .foregroundColor(AppTheme.Colors.primary)
                }
                
                // --- Başlıklar ---
                VStack(spacing: 12) {
                    Text("Bulunduğun şehri\nöğrenelim")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Namaz vakitlerini doğru göstermek için konumuna ihtiyacımız var. Bu sayede ibadetlerini vaktinde eda edebilirsin.")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                // --- Gizlilik Garantisi Kartı ---
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(AppTheme.Colors.tertiary) // Kehribar rengi yıldız
                        .font(.system(size: 20))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GİZLİLİK GARANTİSİ")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.Colors.primary)
                        
                        Text("Konum verilerin asla üçüncü taraflarla paylaşılmaz ve yalnızca vakit hesaplama için kullanılır.")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white) // Beyaz kart
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.03), radius: 5, y: 2)
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Spacer()
                
                // --- Butonlar ---
                VStack(spacing: 16) {
                    // Konumu Paylaş Butonu
                    Button(action: {
                        // TODO: İleride Phase 2'de CoreLocation ile gerçek GPS çağırılacak.
                        userCity = "Otomatik Konum"
                        completeOnboarding() // BİTİR!
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                                .font(.system(size: 14))
                            Text("Konumu Paylaş")
                        }
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: AppTheme.Colors.primary.opacity(0.3), radius: 10, y: 5)
                    }
                    
                    // Manuel Seç Butonu (Tasarımındaki ince çerçeveli hafif buton)
                    Button(action: {
                        // TODO: Şehir şeçme penceresi açılır. Şimdilik geçiyoruz.
                        userCity = "İstanbul"
                        completeOnboarding() // BİTİR!
                    }) {
                        Text("Manuel Seç")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.Colors.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 24)
                
                // --- En Alt Gizlilik Metni ---
                Text("Devam ederek Kullanım Koşulları ve Gizlilik Politikamızı kabul etmiş olursunuz.")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
            }
        }
    }
    
    // Onboarding'i tamamen kapatıp bizi uygulamanın içine sokan sihirli fonksiyon ✨
    private func completeOnboarding() {
        withAnimation(.easeInOut) {
            hasSeenOnboarding = true
        }
    }
    }


#Preview {
    _LocationStepView(currentStep: .constant(4))
}
