//
//  ViewController.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import UIKit

class PokemonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    private let pokemonNameService: PokemonNameService
    private var pokemonList: [PokemonName] = []
    private var offset: Int = 0
    private var batchSize: Int = 40
    
    private let tableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pokemonNameCell")
        return tableView
    }()
    
    init(pokemonNameService: PokemonNameService) {
        self.pokemonNameService = pokemonNameService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonNameCell", for: indexPath)
        let pokemon = pokemonList[indexPath.row]
        cell.textLabel?.text = String(format: "#%04d \(pokemon.name.capitalized)", indexPath.row + 1)
        cell.textLabel?.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .regular)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = pokemonList[indexPath.row]
        let pokemonVC = PokemonViewController(pokemonService: PokemonFetcher(pokemonName: pokemon.name, localCache: CoreDataPokemonDB.shared))
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(pokemonVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > tableView.contentSize.height - 300 - scrollView.frame.size.height {
            guard pokemonNameService.isFetching == false else {
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.tableFooterView = self.createSpinningFooter()
            }
            
            pokemonNameService.fetchPokemonNames(offset: offset, batchSize: batchSize) { [weak self] result in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
                switch result {
                case .success(let newPokemon):
                    self?.pokemonList.append(contentsOf: newPokemon)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    self?.offset += self?.batchSize ?? 0
                case .failure(let error):
                    print("ERROR: \(error)")
                }
            }
        }
    }
    
    private func createSpinningFooter() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        footer.addSubview(spinner)
        spinner.center = footer.center
        
        return footer
    }
}

