//
//  PokemonProfileView.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import UIKit

protocol PokemonProfileViewDelegate: AnyObject {
    func pokemonProfileTapped(_ pokemonName: String)
}

// Displays the image and type of pokemon
class PokemonProfileView: UIView {
    
    weak var delegate: PokemonProfileViewDelegate?
    
    private let pokemonService: PokemonNameService
    private var pokemonName: String?
    
    private let nameLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let pokemonImage = {
        let image = LoadingImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let typeStackView = {
        let stackView = PokemonTypeLabelStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(pokemonService: PokemonNameService) {
        self.pokemonService = pokemonService
        super.init(frame: .zero)
        addSubview(nameLabel)
        addSubview(pokemonImage)
        addSubview(typeStackView)
        addConstraints()
        setupTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapView() {
        guard let pokemonName = pokemonName else { return }
        delegate?.pokemonProfileTapped(pokemonName)
    }
    
    func configure(with pokemonName: String) {
        self.pokemonName = pokemonName
        pokemonService.fetchPokemon(name: pokemonName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async { [weak self] in
                    self?.configure(with: pokemon)
                }
            case .failure(let error):
                print("FAILED TO LOAD POKEMON: \(error)")
            }
        }
    }
    
    private func configure(with pokemon: Pokemon) {
        nameLabel.text = String(format: "#%04d \(pokemon.name.capitalized)", pokemon.id)
        pokemonImage.load(pokemon.imageURL)
        typeStackView.configure(with: pokemon.typeEnums)
    }
    
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            pokemonImage.topAnchor.constraint(equalTo: topAnchor),
            pokemonImage.bottomAnchor.constraint(equalTo: nameLabel.topAnchor),
            pokemonImage.widthAnchor.constraint(equalToConstant: 100),
            pokemonImage.heightAnchor.constraint(equalToConstant: 100),
            pokemonImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        constraints.append(contentsOf: [
            nameLabel.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: typeStackView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        constraints.append(contentsOf: [
            typeStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            typeStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            typeStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            typeStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -0),
        ])
        
        let widthAnchor = widthAnchor.constraint(equalToConstant: 200)
        let heightAnchor = heightAnchor.constraint(equalToConstant: 200)
        widthAnchor.priority = UILayoutPriority(999)
        heightAnchor.priority = UILayoutPriority(999)
        
        constraints.append(contentsOf: [widthAnchor, heightAnchor])
        
        NSLayoutConstraint.activate(constraints)
    }
}
