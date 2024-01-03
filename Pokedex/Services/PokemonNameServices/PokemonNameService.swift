//
//  PokemonNameService.swift
//  Pokedex
//
//  Created by Tyler Gee on 1/2/24.
//

import Foundation

protocol PokemonNameService {
    func fetchPokemonNames(offset: Int, batchSize: Int, completion: @escaping (Result<[PokemonName], Error>) -> Void)
    func fetchPokemon(name: String, completion: @escaping (Result<Pokemon, Error>) -> Void)
    
    var isFetching: Bool { get }
}

enum PokemonNameServiceError: Error {
    case failedToGetOffset
    case localCacheFailure
}
