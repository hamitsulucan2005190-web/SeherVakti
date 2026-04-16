
import SwiftUI

struct AppTheme {
    
    // Tasarımda belirlenen ana renkler (Stitch HEX değerleri)
    struct  Colors {
      
       // Orman Yeşili - Ana ana tema rengimiz (hex: etiketi kaldırıldı)
                static let primary = Color("#1C7C54")
                // Kehribar - Vurgu ve ödül anları için
                static let tertiary = Color("#D4A373")
                // Yumuşak arka plan rengi
                static let background = Color("#f9f9fe")
                // Kartlar ve bölümler için alt katman rengi
                static let surfaceLow = Color("#f3f3f8")
                // En üstte duran beyaz kart rengi
                static let surfaceLowest = Color("#ffffff")
        
        
        
    }
    
    
    // Köşe yuvarlatma değerleri
    struct Radius {
        // Ana kartlar için 24pt kuralı
                static let mainCard: CGFloat = 24
    }
}

extension Color {
     init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
   
    
}
