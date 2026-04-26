//
//  NameInputStepView.swift
//  SeherVakti
//
//  Created by Hamit Sulucan on 26.04.2026.
//

import SwiftUI

struct NameInputStepView: View {
    // Sayfalar arası geçişi sağlamak için
        @Binding var currentStep: Int
        
    // Kullanıcının ismini kalıcı hafızaya kaydetmek için
        @AppStorage("userName") private var userName: String = ""
        
        // Anlık olarak klavyeden girilen metni tutan değişken
        @State private var nameInput: String = ""
    var body: some View {
        ZStack{
            AppTheme.Colors.background.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24){
                HStack {
                    // Geri Tuşu
                                        Button(action: {
                                            withAnimation(.easeInOut) {
                                                currentStep -= 1 // 1. adıma dön
                                            }
                                        }) {
                                            Image(systemName: "arrow.left")
                                                                        .font(.system(size: 20))
                                                                        .foregroundColor(AppTheme.Colors.primary) // Orman yeşili
                                                                        .padding(12)
                                                                        .background(Color.white)
                                                                        .clipShape(Circle())
                                                                        .shadow(color: .black.opacity(0.05), radius: 5)
                                        }
                    Spacer()
                    
                    HStack(spacing:8){
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                             Capsule().fill(AppTheme.Colors.primary).frame(width: 24, height: 4) // Aktif olan 2. Adım
                             Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                             Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                    }
                    .padding(.trailing, 40) // İndikatörü ortalamak için boşluk dengesi
                    Spacer()
                }
                .padding(.top,20)
                // --- El İkonu
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                                           .fill(AppTheme.Colors.primary.opacity(0.1)) // Çok saydam yeşil zemin
                                           .frame(width: 60, height: 60)
                                       
                                       Image(systemName: "hand.raised.fill")
                                           .font(.system(size: 28))
                                           .foregroundColor(AppTheme.Colors.primary)
                    
                }
                .padding(.top,20)
                // --- Başlıklar ---
                VStack(alignment: .leading, spacing: 8){
                    Text("Seni nasıl\nçağıralım?")
                                           .font(.system(size: 34, weight: .bold, design: .rounded))
                                           .foregroundColor(AppTheme.Colors.primary)
                                       
                                       Text("Bu isim uygulamada seni karşılamak için kullanılacak")
                                           .font(.system(size: 16, design: .rounded))
                                           .foregroundColor(.secondary)
                                           .padding(.top, 8)
                }
                // --- İsim Giriş Alanı ---
                TextField("Adını yaz...", text: $nameInput)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard / 1.5))
                                    .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                                    .padding(.top, 20)
                                
                                Spacer()
                // --- Devam Et Butonu ---
                                Button(action: {
                                    // Kullanıcı isim girmediyse boş kalmasın diye Misafir diyoruz
                                    userName = nameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Misafir" : nameInput
                                    // 3. Adıma geçiyoruz
                                    withAnimation(.easeInOut) {
                                        currentStep = 3
                                    }
                                }) {
                                    HStack {
                                        Text("Devam Et")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppTheme.Colors.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                // --- Alt Bilgi ---
                                Text("ADIM 2 / 4")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary.opacity(0.5))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 20)
                            }
                            .padding(.horizontal, 24)
                                
            }
        }
       
    }


#Preview {
    NameInputStepView(currentStep: .constant(2))
}
