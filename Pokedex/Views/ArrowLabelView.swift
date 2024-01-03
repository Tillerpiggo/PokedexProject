//
//  ArrowLabelView.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import Foundation
import UIKit

class ArrowLabelView: UIView {
    private let label = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let arrow = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.right.circle.fill")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .gray
        view.contentMode = .scaleToFill
        return view
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        addSubview(label)
        addSubview(arrow)
        label.text = text
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        let constraints = [
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: arrow.bottomAnchor, constant: 6),
            
            arrow.heightAnchor.constraint(equalToConstant: 32),
            arrow.widthAnchor.constraint(equalToConstant: 32),
            arrow.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            widthAnchor.constraint(equalToConstant: 48),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
