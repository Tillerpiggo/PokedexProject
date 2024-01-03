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
    
    var textColor: UIColor {
        return .white
    }
}

// Helper extension to define custom colors
extension UIColor {
    static let normalBeige = UIColor(red: 168/255, green: 167/255, blue: 122/255, alpha: 1.0)
    static let fireRed = UIColor(red: 237/255, green: 109/255, blue: 18/255, alpha: 1.0)
    static let waterBlue = UIColor(red: 99/255, green: 144/255, blue: 240/255, alpha: 1.0)
    static let electricYellow = UIColor(red: 247/255, green: 208/255, blue: 44/255, alpha: 1.0)
    static let grassGreen = UIColor(red: 122/255, green: 199/255, blue: 76/255, alpha: 1.0)
    static let iceBlue = UIColor(red: 150/255, green: 217/255, blue: 214/255, alpha: 1.0)
    static let fightingOrange = UIColor(red: 194/255, green: 46/255, blue: 40/255, alpha: 1.0)
    static let poisonPurple = UIColor(red: 163/255, green: 62/255, blue: 161/255, alpha: 1.0)
    static let groundBrown = UIColor(red: 226/255, green: 191/255, blue: 101/255, alpha: 1.0)
    static let flyingLavender = UIColor(red: 169/255, green: 143/255, blue: 243/255, alpha: 1.0)
    static let psychicPink = UIColor(red: 249/255, green: 85/255, blue: 135/255, alpha: 1.0)
    static let bugGreen = UIColor(red: 166/255, green: 185/255, blue: 26/255, alpha: 1.0)
    static let rockGray = UIColor(red: 182/255, green: 161/255, blue: 54/255, alpha: 1.0)
    static let ghostPurple = UIColor(red: 111/255, green: 88/255, blue: 152/255, alpha: 1.0)
    static let dragonBlue = UIColor(red: 111/255, green: 53/255, blue: 252/255, alpha: 1.0)
    static let darkBlack = UIColor(red: 112/255, green: 87/255, blue: 70/255, alpha: 1.0)
    static let steelGray = UIColor(red: 183/255, green: 183/255, blue: 206/255, alpha: 1.0)
    static let fairyPink = UIColor(red: 214/255, green: 133/255, blue: 173/255, alpha: 1.0)
}
