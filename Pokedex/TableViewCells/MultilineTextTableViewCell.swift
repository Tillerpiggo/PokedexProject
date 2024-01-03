//
//  MultilineTextTableViewCell.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import UIKit

class MultilineTextTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 0
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        guard let textLabel = textLabel else { return }
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            textLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with text: String) {
        textLabel?.text = text
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
