import SwiftUI

struct PrayerRow: View {
    let prayer: PrayerTime
    let isCompleted: Bool // Veritabanında kılındı mı bilgisi
    let onTap: () -> Void // Tıklandığında yapılacak işlem (Closure)
    
    var body: some View {
        
        HStack {
            // TIK BUTONU
            Button(action: onTap)
            {
                
                VStack(alignment: .leading, spacing: 4){
                    Text(prayer.name)
                        .font(.system(size: 18, weight: .bold,design: .rounded))
                        .foregroundColor(isCompleted ? .secondary : AppTheme.Colors.primary) // Kılınınca rengi soluklaştır
                    Text(prayer.date, style: .time) // Saati otomatik formatlar
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                Spacer()
                // 2. Sağ Kısım: Durum İkonu (Tamamlandı mı?)
                ZStack{
                    Circle()
                        .stroke(isCompleted ? AppTheme.Colors.primary : Color.secondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.primary)
                            .font(.system(size: 28))
                    }
                    
                }
            }
            .padding(.all,16)
            // 3. Katman Kuralı: Çizgi yerine arka plan rengiyle ayırıyoruz
            .background(isCompleted ? AppTheme.Colors.surfaceLow : AppTheme.Colors.surfaceLowest)
            .clipShape(RoundedRectangle(cornerRadius: 16)) // Köşe yuvarlatma
        }
        .buttonStyle(PlainButtonStyle()) // Butonun varsayılan mavi rengini ve animasyonunu kapatır
    }
}
           
    
    


#Preview {
    PrayerRow(prayer: PrayerTime(name: "Öğle", date: Date()), isCompleted: true) {
        print("Tıklandı")
    }
}

