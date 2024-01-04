//
//  ViewController.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import UIKit

class PokemonListViewController: UITableViewController, Paginating {
    let paginationManager: PaginationManager
    
    init(pokemonNameService: PokemonNameService) {
        self.paginationManager = PaginationManager(pokemonNameService: pokemonNameService)
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pokemonNameCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    // Table View Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginationManager.pokemonList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonNameCell", for: indexPath)
        let pokemon = paginationManager.pokemonList[indexPath.row]
        cell.textLabel?.text = String(format: "#%04d \(pokemon.name.capitalized)", indexPath.row + 1)
        cell.textLabel?.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .regular)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = paginationManager.pokemonList[indexPath.row]
        let pokemonVC = PokemonViewController(pokemonService: PokemonFetcher(pokemonName: pokemon.name, localCache: CoreDataPokemonDB.shared))
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(pokemonVC, animated: true)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fetchDataIfNearBottom(of: scrollView)
    }
}

