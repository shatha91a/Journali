
import SwiftUI

// MARK: - App Colors

enum AppColors {

    // Primary
    static let primary = Color(hex: 0x7F81FF)

    // Text Colors
    static let textAccent = Color(hex: 0xAF99FD)
    static let primaryText = Color(hex: 0xFFFFFF)
    static let secondaryText = Color(hex: 0xA39A9A)

    // Background Colors
    static let background = Color(hex: 0x000000)
    static let surface = Color(hex: 0x1C1C1E)

    // Semantic Colors
    static let destructive = Color(hex: 0xFD453C)
}


// MARK: - App Typography

enum AppFonts {

    static let display = Font.system(
        size: 42,
        weight: .black,
        design: .default
    )

    static let headingLarge = Font.system(
        size: 34,
        weight: .bold,
        design: .default
    )

    static let headingMedium = Font.system(
        size: 24,
        weight: .bold,
        design: .default
    )

    static let titleCard = Font.system(
        size: 24,
        weight: .semibold,
        design: .default
    )

    static let bodyLarge = Font.system(
        size: 20,
        weight: .regular,
        design: .default
    )

    static let bodyMedium = Font.system(
        size: 18,
        weight: .regular,
        design: .default
    )

    static let bodySupporting = Font.system(
        size: 18,
        weight: .light,
        design: .default
    )

    static let captionMedium = Font.system(
        size: 16,
        weight: .regular,
        design: .default
    )

    static let captionSmall = Font.system(
        size: 14,
        weight: .regular,
        design: .default
    )
}


// MARK: - App Spacing

enum AppSpacing {

    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
}


// MARK: - Color Hex Support

extension Color {

    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
