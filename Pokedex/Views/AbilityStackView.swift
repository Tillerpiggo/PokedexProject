//
//  AbilityStackView.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import Foundation
import UIKit

protocol AbilityStackViewDelegate: AnyObject {
    func abilityTapped(_ ability: Ability)
}

class AbilityStackView: UIView, AbilityViewDelegate {
    
    weak var delegate: AbilityStackViewDelegate?
    
    private let stack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stack)
        addConstraints()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with abilities: [Ability]) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for ability in abilities {
            let abilityView = AbilityView()
            abilityView.configure(with: ability)
            abilityView.delegate = self
            stack.addArrangedSubview(abilityView)
        }
        layoutIfNeeded()
    }
    
    func addConstraints() {
        let topAnchor = stack.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        topAnchor.priority = UILayoutPriority(999)
        let constraints = [
            topAnchor,
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func abilityViewTapped(_ ability: Ability) {
        delegate?.abilityTapped(ability)
    }
}

protocol AbilityViewDelegate: AnyObject {
    func abilityViewTapped(_ ability: Ability)
}

class AbilityView: UIView {
    
    weak var delegate: AbilityViewDelegate?
    private var ability: Ability?
    
    private let labelStack = {
        let labelStack = UIStackView()
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.distribution = .fillProportionally
        labelStack.spacing = 2
        labelStack.isUserInteractionEnabled = true
        return labelStack
    }()
    
    private let isHiddenLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Hidden Ability"
        return label
    }()
    
    private let label = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(labelStack)
        labelStack.addArrangedSubview(label)
        addConstraints()
        setupTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with ability: Ability) {
        self.ability = ability
        
        label.text = ability.ability.name.parsingHyphens()
        if ability.is_hidden && labelStack.arrangedSubviews.count == 1 {
            labelStack.addArrangedSubview(isHiddenLabel)
        }
        layoutIfNeeded()
    }
    
    private func setupTapGestureRecognizer() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapView() {
        print("ABILITY VIEW TAPPED!!!")
        guard let ability = ability else {
            print("ERROR: Ability tapped but ability not yet registered")
            return
        }
        delegate?.abilityViewTapped(ability)
    }
    
    private func addConstraints() {
        let topConstraint = labelStack.topAnchor.constraint(equalTo: topAnchor)
        topConstraint.priority = UILayoutPriority(999)
        let constraints = [
            topConstraint,
            labelStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
