//
//  StatsTableViewCell.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import Foundation
import UIKit

class StatsTableViewCell: UITableViewCell {
    private let statsView = {
        let statsView = StatsView()
        statsView.translatesAutoresizingMaskIntoConstraints = false
        return statsView
    }()
    
    private let label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statsView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with stats: [PokemonStatEntry]) {
        label.text = "\(stats.first!.base_stat)"
        statsView.configure(with: stats)
    }
    
    private func addConstraints() {
        let constraints = [
            statsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            statsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
