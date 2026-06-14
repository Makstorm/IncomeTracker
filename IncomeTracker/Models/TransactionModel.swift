//
//  TransactionModel.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 12.06.2026.
//

import Foundation

struct TransactionModel {
    let id: UUID
    let amount: Double
    let type: TransactionType
    let note: String
    let date: Date
    let createdAt: Date
    let categoryId: UUID
}
