//
//  StatsView.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import Foundation
import UIKit

class StatsView: UIView {
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with stats: [PokemonStatEntry]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for stat in stats {
            let statView = StatView()
            statView.configure(with: stat)
            stackView.addArrangedSubview(statView)
        }
        layoutIfNeeded()
    }
    
    private func addConstraints() {
        let topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor)
        topConstraint.priority = UILayoutPriority(999)
        let constraints = [
            topConstraint,
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

class StatView: UIView {
    
    private var progressBarWidthConstraint: NSLayoutConstraint?
    
    private let statLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let progressRect = {
        let rect = UIView()
        rect.layer.cornerRadius = 4
        rect.clipsToBounds = true
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()
    
    private let backgroundRect = {
        let rect = UIView()
        rect.layer.cornerRadius = 4
        rect.clipsToBounds = true
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundRect)
        addSubview(progressRect)
        addSubview(statLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with stat: PokemonStatEntry) {
        statLabel.text = stat.displayName
        statLabel.textColor = .statLabelTextColor
        if let widthConstraint = progressBarWidthConstraint {
            NSLayoutConstraint.deactivate([widthConstraint])
            let newConstraint = progressRect.widthAnchor.constraint(equalTo: backgroundRect.widthAnchor, multiplier: CGFloat(stat.base_stat) / 255.0)
            addConstraint(newConstraint)
        }
        
        progressRect.backgroundColor = stat.color
        backgroundRect.backgroundColor = stat.backgroundColor
        
        layoutIfNeeded()
    }
    
    private func addConstraints() {
        let heightConstraint = heightAnchor.constraint(equalToConstant: 30)
        heightConstraint.priority = UILayoutPriority(999)
        var constraints = [
            statLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            statLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            statLabel.widthAnchor.constraint(equalToConstant: 44),
            
            backgroundRect.topAnchor.constraint(equalTo: topAnchor),
            backgroundRect.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundRect.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundRect.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightConstraint,
            
            progressRect.topAnchor.constraint(equalTo: topAnchor),
            progressRect.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressRect.leadingAnchor.constraint(equalTo: backgroundRect.leadingAnchor),
        ]
        progressBarWidthConstraint = progressRect.widthAnchor.constraint(equalTo: backgroundRect.widthAnchor, multiplier: 0.0)
        constraints.append(progressBarWidthConstraint!)
        NSLayoutConstraint.activate(constraints)
    }
}
