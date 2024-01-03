//
//  LoadingTextview.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import Foundation
import UIKit

// Starts off like its loading, and when configured with text, stops loading
// Given the text externally
class LoadingTextTableViewCell: UITableViewCell {
    
    private let spinner = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        spinner.stopAnimating()
        spinner.isHidden = true
        
        textLabel?.text = text
    }
    
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(spinner.centerXAnchor.constraint(equalTo: centerXAnchor))
        constraints.append(spinner.centerYAnchor.constraint(equalTo: centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}
