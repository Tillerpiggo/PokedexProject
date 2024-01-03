//
//  CoreDataStack.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/24/23.
//

import Foundation
import CoreData

// Singleton CoreDataStack for use by services - NOT BY VIEW CONTROLLERS
class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() { } // Enforce Singleton pattern
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error: \(error)")
            }
        }
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveContext() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if viewContext.hasChanges {
                do {
                    try viewContext.save()
                } catch {
                    fatalError("Error in CoreDataStack.saveContext(): \(error)")
                }
            }
        }
    }
    
}
