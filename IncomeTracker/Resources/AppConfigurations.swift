//
//  AppColors.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 12.06.2026.
//

import UIKit

enum AppColors {
    static let accent = UIColor(hex: "#6C63FF")
    static let income = UIColor(hex: "#2ECC71")
    static let expense = UIColor(hex: "#E74C3C")
    static let background = UIColor.systemBackground
    static let card = UIColor.secondarySystemBackground
    static let textPrimary = UIColor.label
    static let textSecondary = UIColor.secondaryLabel
}

enum AppFonts {
    static func regular(_ size: CGFloat) -> UIFont { .systemFont(ofSize: size, weight: .regular) }
    static func medium(_ size: CGFloat) -> UIFont  { .systemFont(ofSize: size, weight: .medium) }
    static func semibold(_ size: CGFloat) -> UIFont { .systemFont(ofSize: size, weight: .semibold) }
    static func bold(_ size: CGFloat) -> UIFont    { .systemFont(ofSize: size, weight: .bold) }
}

enum AppConstants {
    enum Padding {
        static let xs: CGFloat  = 4
        static let sm: CGFloat  = 8
        static let md: CGFloat  = 16
        static let lg: CGFloat  = 24
        static let xl: CGFloat  = 32
    }
    
    enum CornerRadius {
        static let sm: CGFloat  = 8
        static let md: CGFloat  = 12
        static let lg: CGFloat  = 16
        static let card: CGFloat = 20
    }
}
