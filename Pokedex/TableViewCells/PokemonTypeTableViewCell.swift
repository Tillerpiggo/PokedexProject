//
//  PokemonTypeTableViewCell.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import Foundation
import UIKit

class PokemonTypeTableViewCell: UITableViewCell {
    private let stackView = PokemonTypeLabelStackView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(stackView.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with types: [PokemonType]) {
        stackView.configure(with: types)
    }
}
