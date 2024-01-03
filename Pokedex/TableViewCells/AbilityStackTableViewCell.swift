//
//  AbilityStackTableViewCell.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import UIKit

class AbilityStackTableViewCell: UITableViewCell, AbilityStackViewDelegate {
    
    weak var delegate: AbilityStackViewDelegate?
    
    private let abilityStack = {
        let view = AbilityStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(abilityStack)
        abilityStack.delegate = self
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with abilities: [Ability]) {
        abilityStack.configure(with: abilities)
    }
    
    private func addConstraints() {
        let constraints = [
            abilityStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            abilityStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            abilityStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            abilityStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func abilityTapped(_ ability: Ability) {
        delegate?.abilityTapped(ability)
    }

}
