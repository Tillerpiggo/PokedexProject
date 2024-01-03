//
//  LoadingImage.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import UIKit

class LoadingImageView: UIView {
    
    private let imageLoader = ImageLoader()
    
    private let imageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let spinner = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()
    
    private let failedToLoadLabel = {
        let label = UILabel()
        label.text = "Failed to load image :("
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(spinner)
        addSubview(failedToLoadLabel)
        addConstraints()
    }
    
    func load(_ urlString: String) {
        imageLoader.loadImage(urlString: urlString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.imageView.isHidden = false
                    self?.imageView.image = image
                    self?.spinner.isHidden = true
                case .failure:
                    self?.imageView.isHidden = true
                    self?.spinner.isHidden = true
                    self?.failedToLoadLabel.isHidden = false
                    break
                }
            }
        }
    }
    
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(imageView.topAnchor.constraint(equalTo: topAnchor))
        constraints.append(imageView.bottomAnchor.constraint(equalTo: bottomAnchor))
        constraints.append(imageView.leftAnchor.constraint(equalTo: leftAnchor))
        constraints.append(imageView.rightAnchor.constraint(equalTo: rightAnchor))
        
        constraints.append(spinner.centerXAnchor.constraint(equalTo: centerXAnchor))
        constraints.append(spinner.centerYAnchor.constraint(equalTo: centerYAnchor))
        
        constraints.append(failedToLoadLabel.topAnchor.constraint(equalTo: topAnchor))
        constraints.append(failedToLoadLabel.bottomAnchor.constraint(equalTo: bottomAnchor))
        constraints.append(failedToLoadLabel.leftAnchor.constraint(equalTo: leftAnchor))
        constraints.append(failedToLoadLabel.rightAnchor.constraint(equalTo: rightAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
