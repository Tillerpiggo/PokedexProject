//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by Tyler Gee on 12/25/23.
//

import XCTest
import CoreData
@testable import Pokedex

class PokemonNameTests: XCTestCase {
    var mockPersistentContainer: NSPersistentContainer!
    var mockManagedObjectContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        // Set up in-memory persistent container
        mockPersistentContainer = NSPersistentContainer(name: "DataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // In-memory store
        mockPersistentContainer.persistentStoreDescriptions = [description]
        mockPersistentContainer.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        mockManagedObjectContext = mockPersistentContainer.viewContext
    }

    override func tearDown() {
        mockManagedObjectContext = nil
        mockPersistentContainer = nil
        super.tearDown()
    }

    func testPokemonNameToEntityConversion() {
        let pokemonName = PokemonName(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/", nationalNo: 1, isFavorited: false)
        let entity = pokemonName.toEntity(in: mockManagedObjectContext) as? PokemonNameEntity
        
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.name, "Bulbasaur")
        XCTAssertEqual(entity?.url, "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertEqual(entity?.nationalNo, 1)
        XCTAssertEqual(entity?.isFavorited, false)
    }
    
    func testFavoritedPokemonNameToEntityConversion() {
        let pokemonName = PokemonName(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/", nationalNo: 1, isFavorited: true)
        let entity = pokemonName.toEntity(in: mockManagedObjectContext) as? PokemonNameEntity
        
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.name, "Bulbasaur")
        XCTAssertEqual(entity?.url, "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertEqual(entity?.nationalNo, 1)
        XCTAssertEqual(entity?.isFavorited, true)
    }

    func testEntityToPokemonNameConversion() {
        let entity = PokemonNameEntity(context: mockManagedObjectContext)
        entity.name = "Bulbasaur"
        entity.url = "https://pokeapi.co/api/v2/pokemon/1/"
        entity.nationalNo = 1
        entity.isFavorited = false

        let pokemonName = PokemonName(entity: entity)
        
        XCTAssertNotNil(pokemonName)
        XCTAssertEqual(pokemonName?.name, "Bulbasaur")
        XCTAssertEqual(pokemonName?.url, "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertEqual(pokemonName?.nationalNo, 1)
        XCTAssertEqual(pokemonName?.isFavorited, false)
    }
    
    func testFavoritedEntityToPokemonNameConversion() {
        let entity = PokemonNameEntity(context: mockManagedObjectContext)
        entity.name = "Bulbasaur"
        entity.url = "https://pokeapi.co/api/v2/pokemon/1/"
        entity.nationalNo = 1
        entity.isFavorited = true

        let pokemonName = PokemonName(entity: entity)
        
        XCTAssertNotNil(pokemonName)
        XCTAssertEqual(pokemonName?.name, "Bulbasaur")
        XCTAssertEqual(pokemonName?.url, "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertEqual(pokemonName?.nationalNo, 1)
        XCTAssertEqual(pokemonName?.isFavorited, true)
    }
}
