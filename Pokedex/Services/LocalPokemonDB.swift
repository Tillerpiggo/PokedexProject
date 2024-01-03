//
//  LocalPokemonStore.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/24/23.
//

import Foundation
import CoreData

protocol LocalPokemonDB {
    func pokemonNames(offset: Int, batchSize: Int, predicate: NSPredicate?) -> [PokemonName]?
    func makePokemonNameFavorited(withName name: String, isFavorited: Bool)
    //func favoritedPokemonNames() -> [PokemonName]?
    func pokemon(withName name: String, predicate: NSPredicate?) -> Pokemon?
    func addPokemonNames(_ pokemonNames: [PokemonName])
    func addPokemon(_ pokemon: Pokemon)
}

class CoreDataPokemonDB: LocalPokemonDB {
    
    static let shared = CoreDataPokemonDB()
    private lazy var privateManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = coreDataStack.viewContext
        return context
    }()
    
    private let coreDataStack = CoreDataStack.shared
    
    private init() {}
    
    // Gets pokemon names from the start national no to the end national no. Returns nil if it can't get all pokemon in the range from the cache.
    func pokemonNames(offset: Int, batchSize: Int, predicate: NSPredicate?) -> [PokemonName]? {
        let fetchRequest = PokemonNameEntity.fetchRequest()
        
        // Sort by national no.
        let sortDescriptor = NSSortDescriptor(key: "nationalNo", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Only fetch in specified range
        fetchRequest.predicate = predicate
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = batchSize
        
        do {
            let results = try coreDataStack.viewContext.fetch(fetchRequest)
            let pokemonNames = results.compactMap { PokemonName(entity: $0) }
            guard results.count == pokemonNames.count else {
                print("ERROR parsing pokemonName from PokemonNameEntity - got \(results.count) PokemonNameEntities, but could only parse \(pokemonNames.count) PokemonNames")
                return nil
            }
            
            return pokemonNames
        } catch {
            print("ERROR fetching pokemonNames from local cache: \(error)")
            return nil
        }
    }
    
    func pokemonNames(withPredicate predicate: NSPredicate) -> [PokemonName]? {
        let fetchRequest = PokemonNameEntity.fetchRequest()
        
        // Sort by national no.
        let sortDescriptor = NSSortDescriptor(key: "nationalNo", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Predicate
        fetchRequest.predicate = predicate
        
        do {
            let results = try self.coreDataStack.viewContext.fetch(fetchRequest)
            let pokemonNames = results.compactMap { PokemonName(entity: $0) }
            
            guard results.count == pokemonNames.count else {
                print("ERROR parsing pokemonName from PokemonNameEntity (in favoritedPokemonNames) - got \(results.count) PokemonNameEntities, but could only parse \(pokemonNames.count) PokemonNames")
                return nil
            }
            
            return pokemonNames
        } catch {
            print("ERROR in favoritedPokemonNames: \(error)")
            return nil
        }
    }
    
//    func favoritedPokemonNames() -> [PokemonName]? {
//        let fetchRequest = PokemonNameEntity.fetchRequest()
//        
//        // Sort by national no.
//        let sortDescriptor = NSSortDescriptor(key: "nationalNo", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        // Only fetch in specified range
//        let predicate = NSPredicate(format: "isFavorited == %@", NSNumber(value: true))
//        fetchRequest.predicate = predicate
//        
//        do {
//            let results = try self.coreDataStack.viewContext.fetch(fetchRequest)
//            let favoritedPokemonNames = results.compactMap { PokemonName(entity: $0) }
//            
//            guard results.count == favoritedPokemonNames.count else {
//                print("ERROR parsing pokemonName from PokemonNameEntity (in favoritedPokemonNames) - got \(results.count) PokemonNameEntities, but could only parse \(favoritedPokemonNames.count) PokemonNames")
//                return nil
//            }
//            
//            return favoritedPokemonNames
//        } catch {
//            print("ERROR in favoritedPokemonNames: \(error)")
//            return nil
//        }
//    }
    
    func makePokemonNameFavorited(withName name: String, isFavorited: Bool) {
        let fetchRequest = PokemonNameEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        
        do {
            let results = try coreDataStack.viewContext.fetch(fetchRequest)
            guard let fetchedName = results.first else {
                print("Name not found when fetching name")
                return
            }
            
            fetchedName.isFavorited = isFavorited
            coreDataStack.saveContext()
        } catch {
            print("Error fetching specific pokemon name: \(name), error: \(error)")
        }
    }
    
    func pokemon(withName name: String, predicate: NSPredicate?) -> Pokemon? {
        print("searching for pokemon with name: \(name)")
        let fetchRequest = PokemonEntity.fetchRequest()
        let namePredicate = NSPredicate(format: "name == %@", name)
        if let predicate = predicate {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, namePredicate])
        } else {
            fetchRequest.predicate = namePredicate
        }
        
        do {
            let results = try coreDataStack.viewContext.fetch(fetchRequest)
            guard let firstWithName = results.first else {
                print("No pokemon found with name \(name)")
                return nil
            }
            
            guard results.count == 1 else {
                print("Multiple pokemon with name: \(name). Pokemon with duplicate names should never be added to the database. If this happens consistently, consider deleting duplicates.")
                return nil
            }
            print("found pokemon with name: \(firstWithName.name!)")
            return Pokemon(entity: firstWithName)
        } catch {
            print("ERROR fetching specific pokemon from local cache: \(error)")
            return nil
        }
    }
    
    // Adds the pokemon. If there is an existing pokemon with the same name, deletes that.
    func addPokemon(_ pokemon: Pokemon) {
        privateManagedObjectContext.perform { [weak self] in
            guard let self = self else { return }
            
            // Create a fetch request to see if there's an existing Pokemon with the same name.
            let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", pokemon.name)
            
            do {
                // Attempt to fetch an existing Pokemon with the same name.
                let results = try privateManagedObjectContext.fetch(fetchRequest)
                
                // If an existing Pokemon is found, delete it.
                if let existingPokemon = results.first {
                    privateManagedObjectContext.delete(existingPokemon)
                }
                
                let _ = pokemon.toEntity(in: privateManagedObjectContext)
                
                // Save the context after making changes.
                if privateManagedObjectContext.hasChanges {
                    try privateManagedObjectContext.save()
                    DispatchQueue.main.async { [weak self] in
                        self?.coreDataStack.saveContext()
                    }
                }
            } catch {
                // Handle any errors during fetch, delete, or save operations.
                print("ERROR adding Pokemon to local cache: \(error)")
            }
        }
    }
    
    // Adds the pokemon names to the database, overwriting locally if there are any overlaps
    func addPokemonNames(_ pokemonNames: [PokemonName]) {
        privateManagedObjectContext.perform { [weak self] in
            guard let self = self else { return }
            
            // Step 1: Fetch existing PokemonNameEntity objects with the same nationalNo
            let nationalNos = pokemonNames.map { $0.nationalNo }
            let fetchRequest: NSFetchRequest<PokemonNameEntity> = PokemonNameEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "nationalNo IN %@", nationalNos)
            
            do {
                let existingPokemonNames = try privateManagedObjectContext.fetch(fetchRequest)
                
                // Step 2: Delete the fetched objects to avoid duplicates
                for pokemon in existingPokemonNames {
                    privateManagedObjectContext.delete(pokemon)
                }
                
                // Step 3: Insert new PokemonName objects
                for pokemonName in pokemonNames {
                    // Assuming `toEntity(context:)` creates a new `PokemonNameEntity` from a `PokemonName`
                    _ = pokemonName.toEntity(in: privateManagedObjectContext)
                }
                
                // Step 4: Save the context if there are changes
                if privateManagedObjectContext.hasChanges {
                    try privateManagedObjectContext.save()
                    DispatchQueue.main.async { [weak self] in
                        self?.coreDataStack.saveContext()
                    }
                }
            } catch {
                print("ERROR adding pokemon names in local cache: \(error)")
                // TODO: Handle error
            }
        }
    }
}
