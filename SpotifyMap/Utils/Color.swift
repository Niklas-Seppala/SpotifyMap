import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

let BACKGROUND_GRADIENT = Gradient(colors: [
    Color(hex: 0x060224),
    Color(hex: 0x2c207a),
    Color(hex: 0x2c207a),
    Color(hex: 0x3e1366)
])
