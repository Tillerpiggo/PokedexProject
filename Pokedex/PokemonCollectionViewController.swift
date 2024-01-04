//
//  PokemonCollectionViewController.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/25/23.
//

import Foundation
import UIKit

// Displays pokemon profiles in a 2 column collection view
class PokemonCollectionViewController: UIViewController, Paginating {
    func updateRows(at indexPaths: [IndexPath]) {
        collectionView.reloadData()
    }
    
    func showSpinningFooter() {
        // do nothing
    }
    
    func hideSpinningFooter() {
        // do nothing
    }
    
    
    let paginationManager: PaginationManager
    
    private let collectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // Create items that take up 1/3 of the available width, for example
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(1/2))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            // Create groups that are horizontally laid out and fill the width of the collection view
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            // Create a section with the group
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInsetAdjustmentBehavior = .always
        
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return view
    }()
    
    init(pokemonNameService: PokemonNameService) {
        self.paginationManager = PaginationManager(pokemonNameService: pokemonNameService, batchSize: 10)
        super.init(nibName: nil, bundle: nil)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // 1. Create a FavoritedPokemonNameService for this
    // 2. Add pagination to this collectionViewController, modelling it off of the PokemonListViewController, maybe with a different batch size
    
//    private func fetchNames() {
//        //let onlyFavorites = NSPredicate(format: "isFavorited == %@", NSNumber(value: true))
//        self.pokemonNameService.fetchPokemonNames(offset: 0, batchSize: 40) { [weak self] result in
//            print("fetched favorited pokemon names")
//            guard let self = self else { return }
//            print("fetched favorited pokemon names")
//            switch result {
//            case .success(let favoritedPokemonNames):
//                self.pokemonNameList = favoritedPokemonNames
//                DispatchQueue.main.async { [weak self] in
//                    self?.collectionView.reloadData()
//                }
//            case .failure(let error):
//                print("Error fetching pokemon names for PokemonCollectionViewController: \(error)")
//            }
//        }
//    }
    
    //override func viewWillAppear(_ animated: Bool) {
//        self.pokemonNameService.fetchPokemonNames { [weak self] result in
//            print("fetched favorited pokemon names")
//            guard let self = self else { return }
//            print("fetched favorited pokemon names")
//            switch result {
//            case .success(let favoritedPokemonNames):
//                self.pokemonNameList = favoritedPokemonNames
//                DispatchQueue.main.async { [weak self] in
//                    self?.collectionView.reloadData()
//                }
//            case .failure(let error):
//                print("Error fetching pokemon names for PokemonCollectionViewController: \(error)")
//            }
//        }
    //}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension PokemonCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, PokemonProfileViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let profileView = PokemonProfileView(pokemonService: paginationManager.pokemonNameService)
        profileView.configure(with: paginationManager.pokemonList[indexPath.row].name)
        profileView.frame = cell.contentView.bounds
        profileView.delegate = self
        cell.contentView.addSubview(profileView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paginationManager.pokemonList.count
    }
    
    func pokemonProfileTapped(_ pokemonName: String) {
        let pokemonVC = PokemonViewController(pokemonService: PokemonFetcher(pokemonName: pokemonName, localCache: CoreDataPokemonDB.shared))
        
        navigationController?.pushViewController(pokemonVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fetchDataIfNearBottom(of: scrollView)
    }
}
