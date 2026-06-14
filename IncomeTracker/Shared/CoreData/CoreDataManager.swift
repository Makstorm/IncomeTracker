//
//  CoreDataManager.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 12.06.2026.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FinanceTracker")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Core Data save error: \(error)")
        }
    }
}

// Categories Operations
extension CoreDataManager {
    func createCategory(_ model: CategoryModel) {
        let entity = Category(context: context)
        entity.id = model.id
        entity.name = model.name
        entity.icon = model.icon
        entity.colorHex = model.colorHex
        entity.type = model.type.rawValue
        save()
    }
    
    func fetchCategories(type: TransactionType? = nil) -> [CategoryModel] {
        let request = Category.fetchRequest()
        if let type {
            request.predicate = NSPredicate(format: "type == %@", type.rawValue)
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context.fetch(request).map { entity in
                CategoryModel(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "",
                    icon: entity.icon ?? "",
                    colorHex: entity.colorHex ?? "#6C63FF",
                    type:  TransactionType(rawValue: entity.type ?? "") ?? .expense
                )
            }
        } catch {
            print("Fetch catefories error: \(error)")
            return []
        }
    }
    
    func deleteCategory(id: UUID) {
        let request = Category.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                save()
            }
        } catch {
            print("Delete category error: \(error)")
        }
    }
}

// Transactions Operations
extension CoreDataManager {
    func createTransaction(_ model: TransactionModel) {
        let entity = Transaction(context: context)
        entity.id = model.id
        entity.amount = model.amount
        entity.type = model.type.rawValue
        entity.note = model.note
        entity.date = model.date
        entity.createdAt = model.createdAt
        entity.categoryId = model.categoryId
        save()
    }
    
    func fetchTransaction(type: TransactionType? = nil, from: Date? = nil, to: Date? = nil) -> [TransactionModel] {
        let request = Transaction.fetchRequest()
        
        var predicates: [NSPredicate] = []
        
        if let type { predicates.append(NSPredicate(format: "type == %@", type.rawValue)) }
        if let from { predicates.append(NSPredicate(format: "date >= %@", from as CVarArg)) }
        if let to { predicates.append(NSPredicate(format: "date <= %@", to as CVarArg)) }
        
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(request).map { entity in
                TransactionModel(
                    id: entity.id ?? UUID(),
                    amount: entity.amount,
                    type: TransactionType(rawValue: entity.type ?? "") ?? .expense,
                    note: entity.note ?? "",
                    date: entity.date ?? Date(),
                    createdAt: entity.createdAt ?? Date(),
                    categoryId: entity.categoryId ?? UUID()
                )
            }
        } catch {
            print("Fetch transactions error: \(error)")
            return []
        }
    }
    
    func updateTransaction(_ model: TransactionModel) {
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                entity.amount = model.amount
                entity.type = model.type.rawValue
                entity.note = model.note
                entity.date = model.date
                entity.categoryId = model.categoryId
                save()
            }
        } catch {
            print("Update transaction error: \(error)")
        }
    }
    
    func deleteTransaction(id: UUID) {
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                save()
            }
        } catch {
            print("Delete transaction error: \(error)")
        }
    }
}
