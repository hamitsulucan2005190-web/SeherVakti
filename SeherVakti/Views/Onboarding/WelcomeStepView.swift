//
//  WelcomeStepView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 26.04.2026.
//

import SwiftUI

struct WelcomeStepView: View {
    // Ana sayfadan gelen adım değişkenini (Binding ile) alıyoruz ki butona basınca 2. sayfaya geçelim
        @Binding var currentStep: Int
    var body: some View {
        ZStack {
                    // Tasarımındaki gibi hafif degrade (gradient) bir arka plan hissi için
                    AppTheme.Colors.background.ignoresSafeArea()
                    
                    VStack(spacing: 24) {
                        
                        // Üstteki Sayfa İndikatörü (Çizgiler)
                        HStack(spacing: 8) {
                            Capsule().fill(AppTheme.Colors.primary).frame(width: 30, height: 4) // Aktif sayfa
                            Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                            Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                            Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                        }
                        .padding(.top, 60)
                        
                        Spacer()
                        
                        // Yuvarlak İkon (ZStack ile yeşil daire üzerine kitap ve ay ekledik)
                        ZStack {
                            Circle()
                                .fill(AppTheme.Colors.primary)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "book.pages.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            
                            // Ay ikonu sağ üstte
                            Image(systemName: "moon.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppTheme.Colors.tertiary) // Kehribar rengi
                                .offset(x: 35, y: -35)
                        }
                        
                        // Başlık ve Alt Başlık
                        VStack(spacing: 8) {
                            Text("Amel Defteri")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.primary)
                            
                            Text("İbadet yolculuğuna hoş geldin")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        
                        // Görsel Alanı (Şu an yer tutucu bir kutu koyduk, ileride tasarımındaki gibi fotoğraf ekleyebilirsin)
                        RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .overlay(
                                Text("Buraya Pencere Görseli Gelecek")
                                    .foregroundColor(.secondary)
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        // Başla Butonu
                        Button(action: {
                            // Animasyonla 2. sayfaya geçiş yapıyoruz
                            withAnimation(.easeInOut) {
                                currentStep = 2
                            }
                        }) {
                            Text("Başla")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.Colors.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 24)
                        
                        // En alttaki küçük metin
                        Text("ZATEN BİR HESABIN MI VAR?")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 40)
                    }
                }
            }
        
        
    }


#Preview {
    WelcomeStepView(currentStep: .constant(1))
}
