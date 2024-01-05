//
//  PokemonType.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import Foundation
import UIKit

enum PokemonType {
    case normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy
    
    init?(string: String) {
        switch string {
        case "normal": self = .normal
        case "fire": self = .fire
        case "water": self = .water
        case "electric": self = .electric
        case "grass": self = .grass
        case "ice": self = .ice
        case "fighting": self = .fighting
        case "poison": self = .poison
        case "ground": self = .ground
        case "flying": self = .flying
        case "psychic": self = .psychic
        case "bug": self = .bug
        case "rock": self = .rock
        case "ghost": self = .ghost
        case "dragon": self = .dragon
        case "dark": self = .dark
        case "steel": self = .steel
        case "fairy": self = .fairy
        default: return nil
        }
    }
    
    var name: String {
        switch self {
        case .normal: return "Normal"
        case .fire: return "Fire"
        case .water: return "Water"
        case .electric: return "Electric"
        case .grass: return "Grass"
        case .ice: return "Ice"
        case .fighting: return "Fighting"
        case .poison: return "Poison"
        case .ground: return "Ground"
        case .flying: return "Flying"
        case .psychic: return "Psychic"
        case .bug: return "Bug"
        case .rock: return "Rock"
        case .ghost: return "Ghost"
        case .dragon: return "Dragon"
        case .dark: return "Dark"
        case .steel: return "Steel"
        case .fairy: return "Fairy"
        }
    }
    
    var color: UIColor {
        switch self {
        case .normal: return .normalBeige
        case .fire: return .fireRed
        case .water: return .waterBlue
        case .electric: return .electricYellow
        case .grass: return .grassGreen
        case .ice: return .iceBlue
        case .fighting: return .fightingOrange
        case .poison: return .poisonPurple
        case .ground: return .groundBrown
        case .flying: return .flyingLavender
        case .psychic: return .psychicPink
        case .bug: return .bugGreen
        case .rock: return .rockGray
        case .ghost: return .ghostPurple
        case .dragon: return .dragonBlue
        case .dark: return .darkBlack
        case .steel: return .steelGray
        case .fairy: return .fairyPink
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .normal: return UIColor.normalTitle
        case .fire: return UIColor.fireTitle
        case .water: return UIColor.waterTitle
        case .electric: return UIColor.electricTitle
        case .grass: return UIColor.grassTitle
        case .ice: return UIColor.iceTitle
        case .fighting: return UIColor.fightingTitle
        case .poison: return UIColor.poisonTitle
        case .ground: return UIColor.groundTitle
        case .flying: return UIColor.flyingTitle
        case .psychic: return UIColor.psychicTitle
        case .bug: return UIColor.bugTitle
        case .rock: return UIColor.rockTitle
        case .ghost: return UIColor.ghostTitle
        case .dragon: return UIColor.dragonTitle
        case .dark: return UIColor.darkTitle
        case .steel: return UIColor.steelTitle
        case .fairy: return UIColor.fairyTitle
        }
    }
    
    var textColor: UIColor {
        return .white
    }
}
