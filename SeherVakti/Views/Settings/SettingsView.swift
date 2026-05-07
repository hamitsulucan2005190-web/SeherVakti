import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    // Kullanıcı bilgileri
    @AppStorage("userName") private var userName: String = "Misafir"
    @AppStorage("userCity") private var userCity: String = "İstanbul"
     @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true

     // İş mantığı ve senkronizasyon için ViewModel
@State private var viewModel = HistoryViewModel.shared

    @State private var showCalculator = false
    @State private var showCityPicker = false
    @FocusState private var isInputActive: Bool

    // sıfırlama butonu için 
    @State private var showResetAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // 1. PROFİL KARTI
                        profileCard
                        
                        // 2. KİŞİSEL TERCİHLER KARTI (Namaz, Şehir, Bildirim)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Uygulama Ayarları")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.primary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 0) {
                                // Şehir Seçimi
                                cityPickerRow
                                Divider()
                                // Bildirimler
                                ToggleRow(icon: "bell.badge.fill", title: "Namaz Bildirimleri", isOn: $notificationsEnabled)
                                Divider()
                                // Karanlık Mod
                                ToggleRow(icon: "moon.fill", title: "Karanlık Mod", isOn: $isDarkMode)
                            }
                            .padding()
                            .background(AppTheme.Colors.surfaceLowest)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }

                        // 3. KAZA BORCU BELİRLEME KARTI
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Kaza Borcu Belirleme")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(AppTheme.Colors.primary)
                                Spacer()
                                Button {
                                    showCalculator = true
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "magicmockup")
                                        Text("Kaza Borcu Hesapla")
                                    }
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppTheme.Colors.primary.opacity(0.1))
                                    .foregroundColor(AppTheme.Colors.primary)
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal, 4)

                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
    KazaSettingsCard(title: "Sabah", icon: "🌅", value: $viewModel.kazaSabahTotal)
    KazaSettingsCard(title: "Öğle", icon: "☀️", value: $viewModel.kazaOgleTotal)
    KazaSettingsCard(title: "İkindi", icon: "🌤️", value: $viewModel.kazaIkindiTotal)
    KazaSettingsCard(title: "Akşam", icon: "🌆", value: $viewModel.kazaAksamTotal)
    KazaSettingsCard(title: "Yatsı", icon: "🌃", value: $viewModel.kazaYatsiTotal)
    KazaSettingsCard(title: "Vitir", icon: "🌙", value: $viewModel.kazaVitirTotal)
                                }
.padding(.bottom, 12)
// Oruç kazasını ızgaranın altına, daha geniş bir kart olarak ekleyelim
KazaSettingsCard(title: "Kaza Orucu (Gün Sayısı)", icon: "🌙", value: $viewModel.kazaOrucTotal)


                            
                            
                            .padding()
                            .background(AppTheme.Colors.surfaceLowest)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }
                        
                        // 4. DESTEK VE HAKKINDA
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Destek & Uygulama")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.primary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 0) {
                                ActionRow(icon: "star.fill", title: "Uygulamayı Puanla")
                                Divider()
                                // Sıfırlama Butonu
Button(action: {
    showResetAlert = true
}) {
    HStack {
        Image(systemName: "arrow.counterclockwise")
            .font(.title3)
            .foregroundColor(.red)
            .frame(width: 32)
        Text("Uygulamayı Sıfırla")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.red)
        Spacer()
        Image(systemName: "chevron.right")
            .font(.footnote)
            .foregroundColor(.red.opacity(0.5))
    }
    .padding(.vertical, 12)
}


                                ActionRow(icon: "envelope.fill", title: "Bize Ulaşın")
                                Divider()
                                versionInfoRow
                            }
                            .padding()
                            .background(AppTheme.Colors.surfaceLowest)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Ayarlar")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Bitti") {
                        isInputActive = false
                    }
                }
            }
            .sheet(isPresented: $showCalculator) 
            {

                KazaCalculatorView(viewModel: viewModel)
            }
            // Sıfırlama onay dialogu
.alert("Uygulamayı Sıfırla", isPresented: $showResetAlert) {
    Button("İptal", role: .cancel) { }
    Button("Sıfırla", role: .destructive) {
        resetApp()
    }
} message: {
    Text("Tüm veriler silinecek ve uygulama ilk açılış ekranına dönecek. Bu işlem geri alınamaz.")
}
        }
    }

    // --- ALT BİLEŞENLER ---

    private var profileCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(AppTheme.Colors.primary).frame(width: 50, height: 50)
                Text(String(userName.prefix(1)).uppercased()).font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(userName).font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(AppTheme.Colors.primary)
                Text("Dijital Günlüğünüz & İbadet Rehberi").font(.system(size: 14, weight: .medium, design: .rounded)).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding().background(AppTheme.Colors.surfaceLowest).clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard)).shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }

    private var cityPickerRow: some View {
        Button { showCityPicker = true } label: {
            HStack(spacing: 14) {
                // İkon
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primary.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.primary)
                }

                // Başlık + Seçili Şehir
                VStack(alignment: .leading, spacing: 2) {
                    Text("Namaz Vakti Şehri")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.primary)
                    Text(userCity)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Sağ ok
                HStack(spacing: 4) {
                    Text(userCity)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.primary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.Colors.primary.opacity(0.6))
                }
            }
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showCityPicker) {
            CityPickerSheet(selectedCity: $userCity, isPresented: $showCityPicker)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        }
    }

    private var versionInfoRow: some View {
        HStack {
            Image(systemName: "info.circle.fill").font(.title3).foregroundColor(AppTheme.Colors.primary).frame(width: 32)
            Text("Versiyon").font(.system(size: 16, weight: .medium, design: .rounded)).foregroundColor(AppTheme.Colors.primary)
            Spacer()
            Text("v2.4.0").font(.system(size: 14)).foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
    }
    // Uygulamayı fabrika ayarlarına döndüren fonksiyon
private func resetApp() {
    // 1) Tüm AppStorage (UserDefaults) verilerini temizle
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    // 2) hasSeenOnboarding'i sıfırla → Onboarding yeniden başlar
    hasSeenOnboarding = false
}

   

    // Daha profesyonel görünen Kaza Giriş Kartı
    private func KazaSettingsCard (title: String, icon: String, value: Binding<Int>) -> some View{

        VStack(spacing: 8) {
        // İkon ve Başlık
        HStack {
            Text(icon)
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
        }
        .foregroundColor(AppTheme.Colors.primary)
        
        // Giriş Alanı (TextField)
        TextField("0", value: value, format: .number)
                .keyboardType(.numberPad)
                .focused($isInputActive)
            .multilineTextAlignment(.center)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .padding(.vertical, 10)
            .background(AppTheme.Colors.surfaceLow)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.Colors.primary.opacity(0.1), lineWidth: 1)
            )
    }
    .padding(12)
    .background(AppTheme.Colors.surfaceLowest)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    }


}

// --- DESTEKÇİ GÖRÜNÜMLER ---

struct ToggleRow: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool
    var body: some View {
        HStack {
            Image(systemName: icon).font(.title3).foregroundColor(AppTheme.Colors.primary).frame(width: 32)
            Text(title).font(.system(size: 16, weight: .medium, design: .rounded)).foregroundColor(AppTheme.Colors.primary)
            Spacer()
            Toggle("", isOn: $isOn).labelsHidden().tint(AppTheme.Colors.primary)
        }
        .padding(.vertical, 12)
    }
}

struct ActionRow: View {
    var icon: String
    var title: String
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon).font(.title3).foregroundColor(AppTheme.Colors.primary).frame(width: 32)
                Text(title).font(.system(size: 16, weight: .medium, design: .rounded)).foregroundColor(AppTheme.Colors.primary)
                Spacer()
                Image(systemName: "chevron.right").font(.footnote).foregroundColor(.secondary)
            }
            .padding(.vertical, 12)
        }
    }
}




#Preview {
    SettingsView()
}

