//
//  FavoritePokemonNameFetcher.swift
//  Pokedex
//
//  Created by Tyler Gee on 1/2/24.
//

import Foundation

// Since favorited pokemon are added locally, we don't need to fetch data from the API
class FavoritePokemonNameFetcher: PokemonNameService {
    private let predicate = NSPredicate(format: "isFavorited == %@", NSNumber(value: true))
    private let localCache: LocalPokemonDB
    
    var isFetching: Bool = false // LocalPokemonDB should properly queue fetches, so users of this class should never have to wait to send more requests
    
    init(localCache: LocalPokemonDB) {
        self.localCache = localCache
    }
    
    func fetchPokemonNames(offset: Int, batchSize: Int, completion: @escaping (Result<[PokemonName], Error>) -> Void) {
        if let pokemonNames = localCache.pokemonNames(offset: offset, batchSize: batchSize, predicate: predicate) {
            completion(.success(pokemonNames))
        } else {
            completion(.failure(PokemonNameServiceError.localCacheFailure))
        }
    }
    
    func fetchPokemon(name: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        if let pokemon = localCache.pokemon(withName: name, predicate: predicate) {
            completion(.success(pokemon))
        } else {
            completion(.failure(PokemonNameServiceError.localCacheFailure))
        }
    }
}
