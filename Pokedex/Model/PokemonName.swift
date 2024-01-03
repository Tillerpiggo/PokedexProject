//
//  Pokemon.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import Foundation
import CoreData

protocol CoreDataStorable {
    init?(entity: NSManagedObject)
    func toEntity(in context: NSManagedObjectContext) -> NSManagedObject?
}

struct PokemonListResponse: Codable {
    var results: [PokemonName]
    var next: String
}

struct PokemonName: CoreDataStorable, Codable {
    init?(entity: NSManagedObject) {
        guard
            let pokemonNameEntity = entity as? PokemonNameEntity,
            let name = pokemonNameEntity.name,
            let url = pokemonNameEntity.url
        else {
            return nil
        }
        self.name = name
        self.url = url
        self.nationalNo = Int(pokemonNameEntity.nationalNo)
        self.isFavorited = pokemonNameEntity.isFavorited
    }
    
    func toEntity(in context: NSManagedObjectContext) -> NSManagedObject? {
        let entity = PokemonNameEntity(context: context)
        entity.name = self.name
        entity.url = self.url
        entity.nationalNo = Int32(self.nationalNo!)
        entity.isFavorited = self.isFavorited ?? false
        return entity
    }
    
    // For testing. This is typically initialized from an API call or cache.
    init(name: String, url: String, nationalNo: Int?, isFavorited: Bool?) {
        self.name = name
        self.url = url
        self.nationalNo = nationalNo
        self.isFavorited = isFavorited
    }
    
    var name: String
    var url: String
    var nationalNo: Int?
    var isFavorited: Bool? = false
}

