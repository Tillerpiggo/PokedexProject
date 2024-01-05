//
//  PokemonCollectionViewController.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/25/23.
//

import Foundation
import UIKit

// Displays pokemon profiles in a 2 column collection view
class PokemonCollectionViewController: UICollectionViewController, Paginating, PokemonProfileViewDelegate {
    
    let paginationManager: PaginationManager
    
    init(pokemonNameService: PokemonNameService) {
        let layout = PokemonCollectionViewController.createLayout()
        self.paginationManager = PaginationManager(pokemonNameService: pokemonNameService, batchSize: 10)
        super.init(collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pokemonProfileTapped(_ pokemonName: String) {
        let pokemonVC = PokemonViewController(pokemonService: PokemonFetcher(pokemonName: pokemonName, localCache: CoreDataPokemonDB.shared))
        
        navigationController?.pushViewController(pokemonVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let profileView = PokemonProfileView(pokemonService: paginationManager.pokemonNameService)
        profileView.configure(with: paginationManager.pokemonList[indexPath.row].name)
        profileView.frame = cell.contentView.bounds
        profileView.delegate = self
        cell.contentView.addSubview(profileView)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paginationManager.pokemonList.count
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fetchDataIfNearBottom(of: scrollView)
    }
    
    private static func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            return NSCollectionLayoutSection(group: group)
        }
    }
}
