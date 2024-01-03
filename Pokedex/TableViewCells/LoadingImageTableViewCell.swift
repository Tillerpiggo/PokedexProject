//
//  LoadingImageTableViewCell.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import Foundation
import UIKit

class LoadingImageTableViewCell: UITableViewCell {
    
    private let loadingImage = {
        let view = LoadingImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(loadingImage)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure with an image URL
    func configure(with urlString: String) {
        loadingImage.load(urlString)
    }
    
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(loadingImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        let heightConstraint = loadingImage.heightAnchor.constraint(equalToConstant: 240)
        heightConstraint.priority = .defaultHigh
        constraints.append(heightConstraint)
        constraints.append(loadingImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40))
        constraints.append(loadingImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40))
        constraints.append(loadingImage.widthAnchor.constraint(equalToConstant: 240))
        
        NSLayoutConstraint.activate(constraints)
    }
}
