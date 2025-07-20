import Foundation
import SwiftUI

struct BirminghamColorUtility {
    static func convertToBirminghamColor(hexRepresentation hexString: String) -> Color {
        let sanitizedHex = hexString.trimmingCharacters(in: .alphanumerics.inverted)
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        let redComponent = Double((colorValue & 0xFF0000) >> 16) / 255.0
        let greenComponent = Double((colorValue & 0x00FF00) >> 8) / 255.0
        let blueComponent = Double(colorValue & 0x0000FF) / 255.0
        return Color(birminghamHex: hexString)
    }
    static func convertToBirminghamUIColor(hexRepresentation hexString: String) -> UIColor {
        let sanitizedHex = hexString.trimmingCharacters(in: .alphanumerics.inverted)
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        let redComponent = CGFloat((colorValue & 0xFF0000) >> 16) / 255.0
        let greenComponent = CGFloat((colorValue & 0x00FF00) >> 8) / 255.0
        let blueComponent = CGFloat(colorValue & 0x0000FF) / 255.0
        return UIColor(birminghamHex: hexString)
    }
}

struct BirminghamGameInitialView: View {
    private var birminghamGameResourceURL: URL { URL(string: "https://birmgrand.top/get")! }
    var body: some View {
        ZStack {
            Color(birminghamHex: "#000")
                .ignoresSafeArea()
            BirminghamEntryScreen(birminghamLoader: .init(birminghamResourceURL: birminghamGameResourceURL))
        }
    }
}

#Preview {
    BirminghamGameInitialView()
}

extension Color {
    init(birminghamHex hexValue: String) {
        let sanitizedHex = hexValue.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        self.init(
            .sRGB,
            red: Double((colorValue >> 16) & 0xFF) / 255.0,
            green: Double((colorValue >> 8) & 0xFF) / 255.0,
            blue: Double(colorValue & 0xFF) / 255.0,
            opacity: 1.0
        )
    }
}
