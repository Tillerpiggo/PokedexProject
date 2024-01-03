//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import Foundation
import UIKit

class PokemonViewController: UIViewController {

    private let pokemonService: PokemonService
    private var pokemon: Pokemon?
    
    private let refreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private let tableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PokemonTypeTableViewCell.self, forCellReuseIdentifier: "pokemonTypeCell")
        tableView.register(LoadingImageTableViewCell.self, forCellReuseIdentifier: "loadingImage")
        tableView.register(MultilineTextTableViewCell.self, forCellReuseIdentifier: "multilineText")
        tableView.register(EvolutionTreeTableViewCell.self, forCellReuseIdentifier: "evolutionTree")
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: "stats")
        tableView.register(ListPreviewTableViewCell.self, forCellReuseIdentifier: "listPreview")
        tableView.register(AbilityStackTableViewCell.self, forCellReuseIdentifier: "abilityStack")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
        super.init(nibName: nil, bundle: nil)
        self.pokemonService.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        addConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(toggleFavorite))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pokemonService.refresh()
    }
    
    private func addConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        guard let pokemon = pokemon else {
            print("ERROR: Failed to refresh because initial pokemon not loaded. This is probably a major flaw that should be refactored out.")
            return
        }
        pokemonService.refresh()
        sender.endRefreshing()
    }
    
    @objc private func toggleFavorite() {
        pokemonService.toggleFavorite()
        
    }
}

extension PokemonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        guard let pokemon = pokemon else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "loadingImage", for: indexPath)
            (cell as? LoadingImageTableViewCell)?.configure(with: pokemon.imageURL)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "pokemonTypeCell", for: indexPath)
            (cell as? PokemonTypeTableViewCell)?.configure(with: pokemon.typeEnums)
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "abilityStack", for: indexPath)
            (cell as? AbilityStackTableViewCell)?.configure(with: pokemon.abilities)
            (cell as? AbilityStackTableViewCell)?.delegate = self
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "multilineText", for: indexPath)
            let flavorText = pokemon.englishDescription?.parseFlavorText() ?? "Loading description..."
            cell.textLabel?.text = flavorText
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "stats", for: indexPath)
            (cell as? StatsTableViewCell)?.configure(with: pokemon.stats)
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: "listPreview", for: indexPath)
            cell.textLabel?.text = "Moves"
            cell.detailTextLabel?.text = "\(pokemon.moves.count)"
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: "evolutionTree", for: indexPath)
            if let evolutionChain = pokemon.fetchedEvolutionChain, let cell = cell as? EvolutionTreeTableViewCell {
                cell.configure(with: evolutionChain)
                cell.delegate = self
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "CELL NOT CONFIGURED PROPERLY"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 3:
            presentFlavorTextViewController()
        case 5:
            presentMoveListViewController()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = pokemon {
            return 7
        } else {
            return 0
        }
    }
}

extension PokemonViewController: PokemonServiceDelegate, EvolutionTreeViewDelegate, AbilityStackViewDelegate {
    func didUpdatePokemon(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            title = pokemon.name.capitalized
            let textAttributes = [NSAttributedString.Key.foregroundColor: pokemon.typeEnums.first!.color]
            navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: pokemon.isFavorited ?? false ? "heart.fill" : "heart")
            tableView.reloadData()
        }
    }
    
    func didSelectPokemon(_ pokemonName: String) {
        let newPokemonVC = PokemonViewController(pokemonService: PokemonFetcher(pokemonName: pokemonName, localCache: CoreDataPokemonDB.shared))
        navigationController?.pushViewController(newPokemonVC, animated: true)
    }
    
    func abilityTapped(_ ability: Ability) {
        let abilityVC = AbilityDetailsViewController(abilityURL: ability.ability.url)
        navigationController?.pushViewController(abilityVC, animated: true)
    }
    
    private func presentMoveListViewController() {
        guard let pokemon = pokemon else { return }
        
        let moveListVC = MoveListViewController(moves: pokemon.moves)
        navigationController?.pushViewController(moveListVC, animated: true)
    }
    
    private func presentFlavorTextViewController() {
        guard let pokemon = pokemon, let species = pokemon.fetchedSpecies else { return }
        
        let flavorTextListVC = FlavorTextListViewController(species: species)
        navigationController?.present(flavorTextListVC, animated: true)
    }
}
