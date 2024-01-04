//
//  PokemonService.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import Foundation

// This class is responsible for fetching Pokemon names asynchronously
class PokemonNameFetcher: PokemonNameService {
    private(set) var isFetching = false
    private let localCache: LocalPokemonDB
    
    init(localCache: LocalPokemonDB) {
        self.localCache = localCache
    }
    
    // Fetches batchSize pokemon names, starting from the offset (nationalNo - 1). Assumed it will fetch pokemon in order.
    func fetchPokemonNames(offset: Int, batchSize: Int, completion: @escaping (Result<[PokemonName], Error>) -> Void) {
        let url = self.url(forOffset: offset, batchSize: batchSize)
        
        // Ensure the list contains only national numbers within the range. If the count is incorrect (data might be incomplete), fetch again. Fetching from the end of the list allows for seamless updates when new Pokémon are added.
        let predicate = NSPredicate(format: "nationalNo >= %d AND nationalNo <= %d", offset + 1, offset + 1 + batchSize)
        if let pokemonNames = localCache.pokemonNames(offset: offset, batchSize: batchSize, predicate: predicate), pokemonNames.count == batchSize {
            completion(.success(pokemonNames))
            return
        }
        
        isFetching = true
        DataLoader.loadData(urlString: url) { [weak self] (result: Result<PokemonListResponse, Error>) in
            switch result {
            case .success(var pokemonListResponse):
                for i in 0..<batchSize {
                    pokemonListResponse.results[i].nationalNo = offset + i + 1
                }
                self?.localCache.addPokemonNames(pokemonListResponse.results)
                self?.isFetching = false
                completion(.success(pokemonListResponse.results))
            case .failure(let error):
                print("ERROR loading PokemonNameEntities in PokemonNameFetcher: \(error)")
                self?.isFetching = false
                completion(.failure(error))
            }
        }
    }
    
//    func fetchFavoritedPokemonNames(completion: @escaping (Result<[PokemonName], Error>) -> Void) {
//        if let favoritedPokemonNames = localCache.favoritedPokemonNames() {
//            completion(.success(favoritedPokemonNames))
//        } else {
//            completion(.failure(PokemonNameFetcherError.localCacheFailure))
//        }
//    }
    
    // Returns just the basic info for a pokemon without expanding nested URLs
    func fetchPokemon(name: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        if let pokemon = localCache.pokemon(withName: name, predicate: nil) {
            completion(.success(pokemon))
            print("loaded pokemon from cache!!!")
            return
        }
        
        DataLoader.loadData(urlString: url(for: name)) { [weak self] (result: Result<Pokemon, Error>) in
            switch result {
            case .success(let pokemon):
                self?.localCache.addPokemon(pokemon)
                completion(.success(pokemon))
            case .failure(let error):
                print("ERROR loading PokemonNameEntities in PokemonNameFetcher: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    private func url(forOffset offset: Int, batchSize: Int) -> String {
        return "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=\(batchSize)"
    }
    
    private func url(for name: String) -> String {
        return "https://pokeapi.co/api/v2/pokemon/\(name)"
    }
}
