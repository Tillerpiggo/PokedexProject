//
//  FlavorTextListViewController.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import Foundation
import UIKit

class FlavorTextListViewController: UIViewController {
    private var species: PokemonSpecies
    private var englishFlavorTexts: [PokemonSpecies.FlavorText] {
        species.flavor_text_entries.filter { flavorText in
            flavorText.language.name == "en"
        }
    }
    
    private let tableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(MultilineTextTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(species: PokemonSpecies) {
        self.species = species
        super.init(nibName: nil, bundle: nil)
        self.title = "Descriptions"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        addConstraints()
    }
    
    private func addConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension FlavorTextListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = englishFlavorTexts[indexPath.section].flavor_text.parseFlavorText()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let flavorTextEntry = englishFlavorTexts[section]
        return flavorTextEntry.version.name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return englishFlavorTexts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
