//
//  EvolutionTreeTableViewcell.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import Foundation
import UIKit

class EvolutionTreeTableViewCell: UITableViewCell, EvolutionTreeViewDelegate {
    
    weak var delegate: EvolutionTreeViewDelegate?
    
    private let treeView = {
        let view = EvolutionTreeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(treeView)
        treeView.delegate = self
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with evolutionChain: EvolutionChain) {
        treeView.configure(with: evolutionChain)
    }
    
    func didSelectPokemon(_ pokemonURL: String) {
        delegate?.didSelectPokemon(pokemonURL)
    }
    
    private func addConstraints() {
        let constraints = [
            treeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            treeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            treeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            treeView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
