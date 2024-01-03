//
//  EvolutionTreeView.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import Foundation
import UIKit

protocol EvolutionTreeViewDelegate: AnyObject {
    func didSelectPokemon(_ pokemonURL: String)
}

class EvolutionTreeView: UIView, PokemonProfileViewDelegate {
    
    weak var delegate: EvolutionTreeViewDelegate?
    
    private var scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with evolutionChain: EvolutionChain) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview()}
        
        var head: EvolutionChain? = evolutionChain
        while let currentNode = head {
            stackView.addArrangedSubview(createPokemonProfileView(currentNode))
            head = currentNode.evolves_to.first
            
            if let _ = head, let evolutionDetails = head?.evolution_details?.first {
                stackView.addArrangedSubview(ArrowLabelView(text: "(Level \(evolutionDetails.min_level ?? -1))"))
            }
        }
    }
    
    func pokemonProfileTapped(_ pokemonURL: String) {
        delegate?.didSelectPokemon(pokemonURL)
    }
    
    private func createPokemonProfileView(_ evolutionNode: EvolutionChain) -> PokemonProfileView {
        let pokemonProfileView = PokemonProfileView(pokemonService: PokemonNameFetcher(localCache: CoreDataPokemonDB.shared))
        pokemonProfileView.configure(with: evolutionNode.species.name)
        pokemonProfileView.delegate = self
        
        return pokemonProfileView
    }
    
    private func addConstraints() {
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 40),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
