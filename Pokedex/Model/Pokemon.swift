//
//  Pokemon.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import Foundation
import UIKit
import CoreData

struct Pokemon: Codable, CoreDataStorable {
    init?(entity: NSManagedObject) {
        guard let pokemonEntity = entity as? PokemonEntity, let data = pokemonEntity.data else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            self = try decoder.decode(Pokemon.self, from: data)
        } catch {
            print("Error converting PokemonEntity to Pokemon by parsing data: \(error)")
            return nil
        }
    }
    
    func toEntity(in context: NSManagedObjectContext) -> NSManagedObject? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            let pokemonEntity = PokemonEntity(context: context)
            pokemonEntity.name = self.name
            pokemonEntity.data = data
            pokemonEntity.isFavorited = self.isFavorited ?? false
            return pokemonEntity
        } catch {
            print("Error converting Pokemon to PokemonEntity: \(error)")
            return nil
        }
    }
    
    var name: String
    var types: [PokemonTypeEntry]
    var sprites: SpriteEntry
    var species: ExpandableName
    var stats: [PokemonStatEntry]
    var moves: [MoveEntry]
    var abilities: [Ability]
    var id: Int
    var isFavorited: Bool? = false
    
    var fetchedSpecies: PokemonSpecies?
    var fetchedEvolutionChain: EvolutionChain?
    var englishDescription: String? {
        guard let fetchedSpecies = fetchedSpecies else { return nil }
        return fetchedSpecies.flavor_text_entries.first(where: { $0.language.name == "en" })?.flavor_text
    }
    
    var typeEnums: [PokemonType] {
        types.compactMap { PokemonType(string: $0.type.name) }
    }
    
    var imageURL: String {
        return sprites.other.officialArtwork.front_default
    }
}

struct Ability: Codable {
    var ability: ExpandableName
    var is_hidden: Bool
}

struct AbilityDetails: Codable {
    var effect_entries: [EffectEntry]
    var generation: ExpandableName
    var pokemon: [AbilityPokemonEntry]
    var names: [AbilityNameEntry]
    
    struct EffectEntry: Codable {
        var effect: String
        var language: ExpandableName
    }
    
    struct AbilityNameEntry: Codable {
        var language: ExpandableName
        var name: String
    }
}

struct AbilityPokemonEntry: Codable {
    var is_hidden: Bool
    var pokemon: ExpandableName
}

struct PokemonStatEntry: Codable {
    var base_stat: Int
    var stat: PokemonStat
    
    var displayName: String {
        return stat.display.displayName
    }

    var color: UIColor {
        return stat.display.color
    }

    var backgroundColor: UIColor {
        return stat.display.backgroundColor
    }
}

struct PokemonStat: Codable {
    var name: String
    var url: String
    
    enum Display {
        case hp, attack, defense, specialAttack, specialDefense, speed
        
        init(fromName name: String) {
            switch name {
            case "hp": self = .hp
            case "attack": self = .attack
            case "defense": self = .defense
            case "special-attack": self = .specialAttack
            case "special-defense": self = .specialDefense
            case "speed": self = .speed
            default: self = .hp // Default to hp if the name doesn't match
            }
        }
        
        var displayName: String {
            switch self {
            case .hp: return "HP"
            case .attack: return "Atk"
            case .defense: return "Def"
            case .specialAttack: return "Sp. Atk"
            case .specialDefense: return "Sp. Def"
            case .speed: return "Spe"
            }
        }
        
        var color: UIColor {
            switch self {
            case .hp: return UIColor.hpColor
            case .attack: return UIColor.attackColor
            case .defense: return UIColor.defenseColor
            case .specialAttack: return UIColor.specialAttackColor
            case .specialDefense: return UIColor.specialDefenseColor
            case .speed: return UIColor.speedColor
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .hp: return UIColor.hpBackgroundColor
            case .attack: return UIColor.attackBackgroundColor
            case .defense: return UIColor.defenseBackgroundColor
            case .specialAttack: return UIColor.specialAttackBackgroundColor
            case .specialDefense: return UIColor.specialDefenseBackgroundColor
            case .speed: return UIColor.speedBackgroundColor
            }
        }
    }
    
    var display: Display {
        return Display(fromName: name)
    }
}

struct EvolutionChainLink: Codable {
    var url: String
}

struct EvolutionChainEntry: Codable {
    var chain: EvolutionChain
}

class EvolutionChain: Codable {
    var species: SpeciesName
    var evolves_to: [EvolutionChain]
    var evolution_details: [EvolutionDetails]?
    
    struct SpeciesName: Codable {
        var name: String
        var url: String
        
        // Links to the *actual* pokemon entry
        var pokemonURL: String {
            return "https://pokeapi.co/api/v2/pokemon/\(name)"
        }
    }
    
    struct EvolutionDetails: Codable {
        var min_level: Int?
    }
}


struct PokemonSpecies: Codable {
    var flavor_text_entries: [FlavorText]
    var evolution_chain: EvolutionChainLink
    
    struct FlavorText: Codable {
        var flavor_text: String
        var language: ExpandableName
        var version: ExpandableName
    }
}

struct SpriteEntry: Codable {
    var other: OtherSpriteEntry
}

struct OtherSpriteEntry: Codable {
    var officialArtwork: OfficialArtworkEntry
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
    
    struct OfficialArtworkEntry: Codable {
        var front_default: String
    }
}



struct PokemonTypeEntry: Codable {
    var slot: Int
    var type: ExpandableName
}

struct ExpandableName: Codable {
    var name: String
    var url: String
}

struct MoveEntry: Codable {
    var move: ExpandableName
    var version_group_details: [VersionGroupDetail]

    struct VersionGroupDetail: Codable {
        var level_learned_at: Int
        var move_learn_method: ExpandableName
        var version_group: ExpandableName
    }
}

struct VersionResponse: Codable {
    var results: [ExpandableName]
}


