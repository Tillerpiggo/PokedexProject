//
//  Paginating.swift
//  Pokedex
//
//  Created by Tyler Gee on 1/4/24.
//

import Foundation
import UIKit

protocol Paginating: UIScrollViewDelegate {
    var paginationManager: PaginationManager { get }
    func updateRows(at indexPaths: [IndexPath])
    func showSpinningFooter()
    func hideSpinningFooter()
}

// Manages pagination logic for a PokemonNameService, mainly batchSize/offset, errors, and making requests.
// TODO: Make this and PokemonNameService generic (if needed in the future)
class PaginationManager {
    private(set) var pokemonList: [PokemonName]
    var canFetchData: Bool { !pokemonNameService.isFetching }
    
    private var pokemonNameService: PokemonNameService
    private var offset: Int
    private var batchSize: Int
    
    init(pokemonNameService: PokemonNameService, batchSize: Int = 40) {
        self.pokemonNameService = pokemonNameService
        self.pokemonList = []
        self.batchSize = batchSize
        self.offset = 0
    }
    
    // Fetches data from offset, and returns adds data iff found. Returns indexPaths to update. Errors handled internally.
    func fetchMoreData(completion: @escaping ([IndexPath]) -> Void) {
        guard pokemonNameService.isFetching == false else { return }
        
        pokemonNameService.fetchPokemonNames(offset: offset, batchSize: batchSize) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokemonNames):
                pokemonList.append(contentsOf: pokemonNames)
                offset += batchSize
                
                let indexPaths = (offset..<offset + batchSize).map { IndexPath(row: $0, section: 0) }
                completion(indexPaths)
            case .failure(let error):
                print("Error while fetching data to paginate: \(error)")
            }
        }
    }
}

extension Paginating {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > scrollView.contentSize.height - 300 - scrollView.frame.size.height {
            guard paginationManager.canFetchData else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.showSpinningFooter()
            }
            paginationManager.fetchMoreData(completion: { [weak self] indexPaths in
                DispatchQueue.main.async {
                    self?.updateRows(at: indexPaths)
                    self?.hideSpinningFooter()
                }
            })
        }
    }
}
