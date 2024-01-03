//
//  PokemonTypeLabelView.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import UIKit

class PokemonTypeLabelView: UIView {
    private var type: PokemonType
    private let label = UILabel()
    
    init(type: PokemonType) {
        self.type = type
        super.init(frame: .zero)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        addSubview(label)
        
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.clipsToBounds = true
        label.text = type.name.capitalized
        label.textColor = type.textColor
        label.backgroundColor = type.color
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalPadding = 0.0
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }
}

// Horizontally stacked types, from the above
class PokemonTypeLabelStackView: UIView {
    
    private lazy var stackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16))
        constraints.append(stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16))
        constraints.append(stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8))
        constraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8))
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with types: [PokemonType]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for type in types {
            stackView.addArrangedSubview(PokemonTypeLabelView(type: type))
        }
    }
}
