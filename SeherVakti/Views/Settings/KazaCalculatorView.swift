import SwiftUI

struct KazaCalculatorView: View {
    @Environment(\.dismiss) var dismiss

    
  var viewModel: HistoryViewModel

    
    @State private var calculationMode = 0 // 0: Süre Girerek, 1: Yaş ile Hesapla
    
    // Mod 0
    @State private var years: String = ""
    @State private var months: String = ""
    
    // Mod 1
    @State private var currentAge: String = ""
    @State private var pubertyAge: String = "15" // Varsayılan ergenlik yaşı
    
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 12) {
                            Image(systemName: "magicmockup")
                                .font(.system(size: 48))
                                .foregroundColor(AppTheme.Colors.primary)
                                .padding()
                                .background(AppTheme.Colors.primary.opacity(0.1))
                                .clipShape(Circle())
                            
                            Text("Kaza Borcu Hesaplama")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Kaza borcunuzu hesaplamak için bir yöntem seçin.")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 24)
                        
                        Picker("Hesaplama Yöntemi", selection: $calculationMode) {
                            Text("Süre Girerek").tag(0)
                            Text("Yaş ile Hesapla").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        // Giriş Alanları
                        VStack(spacing: 16) {
                            if calculationMode == 0 {
                                HStack(spacing: 16) {
                                    inputField(title: "Yıl", text: $years)
                                    inputField(title: "Ay", text: $months)
                                }
                            } else {
                                HStack(spacing: 16) {
                                    inputField(title: "Şu Anki Yaş", text: $currentAge)
                                    inputField(title: "Ergenlik Yaşı", text: $pubertyAge)
                                }
                            }
                        }
                        .padding()
                        .background(AppTheme.Colors.surfaceLowest)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        .padding(.horizontal)
                        
                        let totalDays = calculateDays()
                        
                        if totalDays > 0 {
                            VStack(spacing: 16) {
                                Text("Toplam Kaza Borcu")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                                Text("\(totalDays) Gün")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundColor(AppTheme.Colors.primary)
                                
                                Button {
                                    applyCalculation(days: totalDays)
                                    dismiss()
                                } label: {
                                    Text("Borçlara Ekle")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(AppTheme.Colors.primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .padding(.top, 8)
                            }
                            .padding()
                            .background(AppTheme.Colors.surfaceLowest)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.mainCard))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                }
                .onTapGesture {
                    isInputActive = false
                }
            }
            .navigationTitle("Kaza Hesaplama")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Bitti") {
                        isInputActive = false
                    }
                }
            }
        }
    }
    
    private func inputField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(AppTheme.Colors.primary)
            
            TextField("0", text: text)
                .keyboardType(.numberPad)
                .focused($isInputActive)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.vertical, 12)
                .background(AppTheme.Colors.surfaceLow)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.Colors.primary.opacity(0.1), lineWidth: 1)
                )
        }
    }
    
    private func getYearsAndMonths() -> (y: Int, m: Int) {
        if calculationMode == 0 {
            let y = Int(years) ?? 0
            let m = Int(months) ?? 0
            return (y, m)
        } else {
            let current = Int(currentAge) ?? 0
            let puberty = Int(pubertyAge) ?? 15
            if current > puberty {
                return (current - puberty, 0)
            } else {
                return (0, 0)
            }
        }
    }
    
    private func calculateDays() -> Int {
        let ym = getYearsAndMonths()
        return (ym.y * 365) + (ym.m * 30)
    }
    
    private func applyCalculation(days: Int) {
        viewModel.kazaSabahTotal += days
        viewModel.kazaOgleTotal += days
        viewModel.kazaIkindiTotal += days
        viewModel.kazaAksamTotal += days
        viewModel.kazaYatsiTotal += days
        viewModel.kazaVitirTotal += days
        
        let ym = getYearsAndMonths()
        let orucDays = ym.y * 30
        viewModel.kazaOrucTotal += orucDays
    }
}
