//
//  CategoryModel.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 12.06.2026.
//

import Foundation

struct CategoryModel {
    let id: UUID
    let name: String
    let icon: String
    let colorHex: String
    let type: TransactionType
}
