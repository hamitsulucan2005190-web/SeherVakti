import SwiftUI

struct FocusView: View {
    // ViewModel'imizi View'e bağladık
    @State private var viewModel = FocusViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Arka plan
                AppTheme.Colors.background.ignoresSafeArea()
                             ScrollView {
                    VStack(spacing: 30) {
                        
                        // --- 1. MOD GEÇİŞ BUTONU ---
                        Picker("Mod Seçimi", selection: $viewModel.currentMode) {
                            Text("Derin Odak").tag(FocusViewModel.FocusMode.focus)
                            Text("Zikirmatik").tag(FocusViewModel.FocusMode.dhikr)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // 🌟 SADECE ODAK MODUNDAYSA GÖSTERİLİR
                        if viewModel.currentMode == .focus {
                            
                            // Sayacı ve Butonları saran tek ve güvenli bir gövde
                            VStack(spacing: 50) {
                                // ÜST KISIM: ZAMANLAYICI VE PROGRESS BAR
                                ZStack {
                                    Circle()
                                        .stroke(AppTheme.Colors.primary.opacity(0.15), lineWidth: 20)
                                        .frame(width: 280, height: 280) // Halka Kilidi
                                    
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(viewModel.progress))
                                        .stroke(AppTheme.Colors.primary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                        .frame(width: 280, height: 280) // Halka Kilidi
                                        .rotationEffect(Angle(degrees: -90))
                                        .animation(.linear(duration: 1.0), value: viewModel.progress)
                                    
                                    VStack(spacing: 8) {
                                        Text("Derin Odak")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundColor(.secondary)
                                        
                                        Text(viewModel.timeString)
                                            .font(.system(size: 64, weight: .bold, design: .rounded))
                                            .foregroundColor(AppTheme.Colors.primary)
                                            .monospacedDigit()
                                        
                                        // Elle zaman girme ve +/- ayarları
                                        if !viewModel.isRunning {
                                            HStack(spacing: 20) {
                                                Button(action: {
                                                    if viewModel.selectedMinutes > 5 { viewModel.selectedMinutes -= 5 }
                                                }) {
                                                    Image(systemName: "minus.circle.fill").font(.title2).foregroundColor(.secondary)
                                                }
                                                
                                                TextField("Dk", value: $viewModel.selectedMinutes, format: .number)
                                                    .keyboardType(.numberPad)
                                                    .multilineTextAlignment(.center)
                                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                                    .foregroundColor(.primary)
                                                    .frame(width: 50)
                                                    .padding(6)
                                                    .background(Color.secondary.opacity(0.1))
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                
                                                Button(action: {
                                                    if viewModel.selectedMinutes < 180 { viewModel.selectedMinutes += 5 }
                                                }) {
                                                    Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(.secondary)
                                                }
                                            }
                                            .padding(.top, 4)
                                        }
                                    }
                                }
                                .padding(.top, 20)
                                
                                // ALT KISIM (BEYAZ ALAN): KONTROLLER (BAŞLAT/BİTİR VE SIFIRLA)
                                VStack(spacing: 16) {
                                    Button(action: {
                                        if viewModel.isRunning { viewModel.stopFocus() }
                                        else { viewModel.startFocus() }
                                    }) {
                                        Text(viewModel.isRunning ? "Odaklanmayı Bitir" : "Odaklanmayı Başlat")
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 18)
                                            .background(viewModel.isRunning ? Color.red.opacity(0.8) : AppTheme.Colors.primary)
                                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                                            .padding(.horizontal, 30)
                                            .animation(.spring(), value: viewModel.isRunning)
                                    }
                                    
                                    Button(action: {
                                        viewModel.resetFocusTimer()
                                    }) {
                                        Text("Süreyi Sıfırla")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(.red.opacity(0.7))
                                    }
                                }
                                .padding(.bottom, 20)
                            }
                        }
                        
                        // 🌟 SADECE ZİKİR MODUNDAYSA GÖSTERİLİR
                        if viewModel.currentMode == .dhikr {
                            VStack(spacing: 24) {
                                // 1. Şık Niyet ve Hedef Kartı
                                VStack(spacing: 20) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Zikrin veya Niyetin")
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                            .foregroundColor(.secondary)
                                            .textCase(.uppercase)
                                        
                                        TextField("Örn: Sübhanallah", text: $viewModel.dhikrTitle)
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                            .foregroundColor(AppTheme.Colors.primary)
                                            .padding(.bottom, 8)
                                            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.secondary.opacity(0.2)), alignment: .bottom)
                                    }
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Hedef Sayısı")
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(AppTheme.Colors.primary)
                                        }
                                        Spacer()
                                        TextField("33", value: $viewModel.dhikrTarget, format: .number)
                                            .keyboardType(.numberPad)
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(AppTheme.Colors.primary)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 70)
                                            .padding(.vertical, 8)
                                            .background(AppTheme.Colors.primary.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                .padding(20)
                                .background(AppTheme.Colors.surfaceLowest)
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                                .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                                .padding(.horizontal, 20)
                                
                                // 2. İlerleyen Zikir Halkası
                                ZStack {
                                    Circle()
                                        .stroke(AppTheme.Colors.primary.opacity(0.15), lineWidth: 15)
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(viewModel.dhikrProgress))
                                        .stroke(AppTheme.Colors.primary, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                        .rotationEffect(Angle(degrees: -90))
                                        .animation(.spring(), value: viewModel.dhikrProgress)
                                    Button(action: {
                                        viewModel.incrementDhikr()
                                    }) {
                                        VStack(spacing: 4) {
                                            Text("\(viewModel.dhikrCount)")
                                                .font(.system(size: 52, weight: .heavy, design: .rounded))
                                                .foregroundColor(AppTheme.Colors.primary)
                                            Text("Tıkla")
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .foregroundColor(AppTheme.Colors.primary.opacity(0.7))
                                        }
                                        .frame(width: 200, height: 200)
                                        .background(AppTheme.Colors.surfaceLowest)
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .frame(width: 250, height: 250)
                                .padding(.top, 10)
                                
                                // 3. Sıfırlama Butonu
                                Button(action: {
                                    viewModel.resetDhikr()
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.counterclockwise")
                                        Text("Zikri Sıfırla")
                                    }
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.red.opacity(0.8))
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentMode)
                }

                // ScrollView ayarları
                .navigationTitle("Zikir & Odak")
                .navigationBarTitleDisplayMode(.inline)
                // Sayfadan çıkarsa timer'ı durdurur
                .onDisappear {
                    viewModel.stopFocus()
                }
            } // 3: ZStack'i kapatır
        } // 4: NavigationStack'i kapatır
    }
}

    

#Preview {
    FocusView()
}
