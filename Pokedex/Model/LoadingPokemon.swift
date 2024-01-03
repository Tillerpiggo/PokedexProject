//
//  LoadingPokemon.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import Foundation
import UIKit

// Struct for managing a pokemon that is dynamically loading extra data that won't be saved
struct LoadingPokemon {
    var pokemon: Pokemon?
    var species: PokemonSpecies?
    var image: UIImage?
}
