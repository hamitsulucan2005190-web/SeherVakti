import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
   
   @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    // isim ve şehir
     @AppStorage("userName") private var userName: String = "Misafir"
    @AppStorage("userCity") private var userCity: String = "Şehir Seçilmedi"

    
    var body: some View {
        NavigationStack {
            ZStack {
                // Design System: Sayfa arka plan rengi (#f9f9fe)
                AppTheme.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Profil Kartı
                        HStack(spacing: 16) {
                            // Profil
                            ZStack {
                                Circle()
                                    .fill(AppTheme.Colors.primary)
                                    .frame(width: 50, height: 50)
                                Text(String(userName.prefix(1)).uppercased())
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            // İsim ve Açıklama
                            VStack(alignment: .leading, spacing: 4) {
                                Text(userName)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(AppTheme.Colors.primary)
                                Text("Dijital Günlüğünüz & İbadet Rehberi")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.secondary.opacity(0.3))
                        }
                        .padding()
                        .background(AppTheme.Colors.surfaceLowest)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        
                        // --- KİŞİSEL TERCİHLER KARTI ---
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Namaz")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.primary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 0) {
                                // Şehir Bilgisi
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.title3)
                                        .foregroundColor(AppTheme.Colors.primary)
                                        .frame(width: 32)
                                    VStack(alignment: .leading) {
                                        Text("Şehir")
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(AppTheme.Colors.primary)
                                        Text(userCity)
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 12)
                                
                                // Hesaplama Yöntemi
                                HStack {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .font(.title3)
                                        .foregroundColor(AppTheme.Colors.primary)
                                        .frame(width: 32)
                                    VStack(alignment: .leading) {
                                        Text("Hesaplama Yöntemi")
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(AppTheme.Colors.primary)
                                        Text("Diyanet İşleri Başkanlığı")
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 12)

                                // Bildirimler
                                ToggleRow(icon: "bell.badge.fill", title: "Namaz Bildirimleri", isOn: $notificationsEnabled)
                                
                                // Karanlık Mod
                                ToggleRow(icon: "moon.fill", title: "Karanlık Mod", isOn: $isDarkMode)
                            }
                            .padding()
                            // Stitch Kuralı: surface_container_lowest (Kart Zemin Rengi)
                            .background(AppTheme.Colors.surfaceLowest)
                            // Stitch Kuralı: Corner Radius: xl (Orta dereceden biraz büyük)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                            // Stitch Kuralı: Ambient Shadow (Yumuşak Gölgelendirme)
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }
                        
                        // --- DESTEK VE UYGULAMA KARTI ---
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Destek & Uygulama")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.primary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 0) {
                                ActionRow(icon: "star.fill", title: "Uygulamayı Puanla")
                                ActionRow(icon: "envelope.fill", title: "Bize Ulaşın")
                            }
                            .padding()
                            .background(AppTheme.Colors.surfaceLowest)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }
                        
                        // --- SÜRÜM VE İMZA BİLGİSİ ---
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Hakkında")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.tertiary)
                                .padding(.horizontal, 4)
                            VStack(spacing: 0) {
                                // Versiyon Bilgisi
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(AppTheme.Colors.primary)
                                        .frame(width: 32)
                                    Text("Uygulama Versiyonu")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(AppTheme.Colors.primary)
                                    Spacer()
                                    Text("v2.4.0")
                                        .font(.system(size: 14, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 12)
                                // Gizlilik
                                HStack {
                                    Image(systemName: "checkmark.shield.fill")
                                        .font(.title3)
                                        .foregroundColor(AppTheme.Colors.primary)
                                        .frame(width: 32)
                                    Text("Gizlilik Politikası")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(AppTheme.Colors.primary)
                                    Spacer()
                                    Image(systemName: "arrow.up.right.square")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 12)
                            }
                            .padding()
                            .background(AppTheme.Colors.surfaceLowest)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
                    .padding(20)
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

// Stitch Özel Liste Satırı (Toggle İçin)
struct ToggleRow: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppTheme.Colors.primary)
                .frame(width: 32)
            
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(AppTheme.Colors.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden() // Toggle'ın kendi ismini gizler
                .tint(AppTheme.Colors.primary)
        }
        .padding(.vertical, 12)
    }
}

// Stitch Özel Liste Satırı (Tıklanabilir Buton İçin)
struct ActionRow: View {
    var icon: String
    var title: String
    
    var body: some View {
        Button(action: {
            // Tıklanınca çalışacak kod
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(AppTheme.Colors.primary)
                    .frame(width: 32)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(AppTheme.Colors.primary)
                
                Spacer()
                
                // Sağ Ok (Apple tarzı Premium hissiyat)
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    SettingsView()
}

