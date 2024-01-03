//
//  SpecificPokemonFetcher.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import Foundation

protocol PokemonServiceDelegate: AnyObject {
    func didUpdatePokemon(_ pokemon: Pokemon)
}

protocol PokemonService: AnyObject {
    var delegate: PokemonServiceDelegate? { get set }
    var pokemon: Pokemon? { get }
    var pokemonName: String { get }
    
    func refresh()
    func toggleFavorite()
}

// Manages fetching the data for a single pokemon entry
class PokemonFetcher: PokemonService {
    
    weak var delegate: PokemonServiceDelegate?
    
    private(set) var pokemon: Pokemon?
    private(set) var pokemonName: String
    private var pokemonNameFetcher: PokemonNameFetcher
    private let localCache: LocalPokemonDB
    
    init(pokemonName: String, localCache: LocalPokemonDB) {
        self.localCache = localCache
        self.pokemonName = pokemonName
        self.pokemonNameFetcher = PokemonNameFetcher(localCache: localCache)
    }
    
    func refresh() {
        pokemonNameFetcher.fetchPokemon(name: pokemonName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedPokemon):
                pokemon = fetchedPokemon
                updatePokemon()
                fetchDescription()
            case .failure(let error):
                print("ERROR FETCHING POKEMON: \(error)")
            }
        }
        fetchDescription()
    }
    
    // Changes pokemon's isFavorited to bool. If it can't find the pokemon, does nothing.
    func toggleFavorite() {
        if pokemon?.isFavorited == nil {
            pokemon?.isFavorited = true
        } else {
            pokemon?.isFavorited?.toggle()
        }
        updatePokemon()
        if let pokemon = pokemon {
            localCache.makePokemonNameFavorited(withName: pokemon.name, isFavorited: pokemon.isFavorited ?? false)
        }
    }
    
    private func fetchDescription() {
        guard let pokemonSpeciesURL = pokemon?.species.url, pokemon?.fetchedSpecies == nil else { return }
        
        fetchData(urlString: pokemonSpeciesURL) { [weak self] (species: PokemonSpecies) in
            guard let self = self else { return }
            
            pokemon?.fetchedSpecies = species
            updatePokemon()
            fetchEvolutionChain()
        }
    }
    
    private func fetchEvolutionChain() {
        guard let fetchedSpecies = pokemon?.fetchedSpecies, pokemon?.fetchedEvolutionChain == nil else { return }
        
        fetchData(urlString: fetchedSpecies.evolution_chain.url) { [weak self] (evolutionChain: EvolutionChainEntry) in
            guard let self = self else { return }
            
            pokemon?.fetchedEvolutionChain = evolutionChain.chain
            updatePokemon()
        }
    }
    
    // Fetches data of a certain type. On success, returns the fetched data. On failure, provides a generic failure message.
    private func fetchData<T: Codable>(urlString: String, completion: @escaping (T) -> Void) {
        DataLoader.loadData(urlString: urlString) { (result: Result<T, Error>) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("ERROR LOADING \(T.self): \(error)")
            }
        }
    }
    
    private func updatePokemon() {
        guard let pokemon = pokemon else { return }
        delegate?.didUpdatePokemon(pokemon)
        localCache.addPokemon(pokemon)
    }
}
