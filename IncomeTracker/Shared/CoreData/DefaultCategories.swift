//
//  DefaultCategories.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 13.06.2026.
//

import Foundation

struct DefaultCategories {
    static func seed(using manager: CoreDataManager = .shared) {
        guard manager.fetchCategories().isEmpty else { return }
        
        let expenses: [(name: String, icon: String, color: String)] = [
            ("Food",          "fork.knife",           "#FF6B6B"),
            ("Transport",     "car.fill",              "#4ECDC4"),
            ("Shopping",      "bag.fill",              "#45B7D1"),
            ("Health",        "heart.fill",            "#96CEB4"),
            ("Entertainment", "tv.fill",               "#FFEAA7"),
            ("Housing",       "house.fill",            "#DDA0DD"),
            ("Education",     "book.fill",             "#98D8C8"),
            ("Other",         "ellipsis.circle.fill",  "#B0B0B0")
        ]
        
        let incomes: [(name: String, icon: String, color: String)] = [
            ("Salary",     "banknote.fill",        "#2ECC71"),
            ("Freelance",  "laptopcomputer",        "#3498DB"),
            ("Investment", "chart.line.uptrend.xyaxis", "#9B59B6"),
            ("Gift",       "gift.fill",             "#E67E22"),
            ("Other",      "ellipsis.circle.fill",  "#B0B0B0")
        ]
        
        expenses.forEach {
            manager.createCategory(CategoryModel(
                id: UUID(), name: $0.name,
                icon: $0.icon, colorHex: $0.color,
                type: .expense
            ))
        }
        
        incomes.forEach {
            manager.createCategory(CategoryModel(
                id: UUID(), name: $0.name,
                icon: $0.icon, colorHex: $0.color,
                type: .income
            ))
        }
    }
}
