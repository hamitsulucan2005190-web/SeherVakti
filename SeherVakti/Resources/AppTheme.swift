
import SwiftUI

struct AppTheme {
    
    // Tasarımda belirlenen ana renkler (Asset Catalog'dan gelir, dark mode'u otomatik destekler)
    struct Colors {
        
        // Ana tema rengi - Asset'ten okunur, Light/Dark otomatik değişir
        static let primary = Color("AppPrimary")
        
        // hex: etiketi ile çağırıyoruz artık
static let tertiary = Color(hex: "#D4A373")

        
        // Sayfa arka plan rengi - Light: #F9F9FE / Dark: #0D0D12
        static let background = Color("AppBackground")
        
        // Kartlar için ara katman - Light: #F3F3F8 / Dark: #16161E
        static let surfaceLow = Color("AppSurfaceLow")
        
        // En üstteki kart zemin rengi - Light: #FFFFFF / Dark: #1C1C24
        static let surfaceLowest = Color("AppSurfaceLowest")
    }
    
    
    // Köşe yuvarlatma değerleri
    struct Radius {
        // Ana kartlar için 24pt kuralı
                static let mainCard: CGFloat = 24
    }
}

extension Color {
    // "hex:" etiketi ekledik — artık Color("AssetAdı") ile çakışmıyor
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 255, 255, 255)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

