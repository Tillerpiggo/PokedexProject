////
////  PokemonView.swift
////  Pokedex
////
////  Created by Tyler Gee on 12/21/23.
////
//
//import UIKit
//
//protocol PokemonViewDelegate: AnyObject {
//    func navigateToPokemon(_ pokemonURL: String)
//}
//
//class PokemonView: UIView, UITableViewDelegate, UITableViewDataSource {
//    
//    private var pokemon: Pokemon?
//    
//    init() {
//        super.init(frame: .zero)
//        addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//        addConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let _ = pokemon {
//            return 5
//        } else {
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: UITableViewCell
//        guard let pokemon = pokemon else {
//            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            return cell
//        }
//        
//        switch indexPath.row {
//        case 0:
//            cell = tableView.dequeueReusableCell(withIdentifier: "loadingImage", for: indexPath)
//            (cell as? LoadingImageTableViewCell)?.configure(with: pokemon.imageURL)
//        case 1:
//            cell = tableView.dequeueReusableCell(withIdentifier: "pokemonTypeCell", for: indexPath)
//            (cell as? PokemonTypeTableViewCell)?.configure(with: pokemon.typeEnums)
//        case 2:
//            cell = tableView.dequeueReusableCell(withIdentifier: "multilineText", for: indexPath)
//            let flavorText = pokemon.englishDescription?.parseFlavorText() ?? "Loading description..."
//            cell.textLabel?.text = flavorText
//        case 3:
//            cell = tableView.dequeueReusableCell(withIdentifier: "stats", for: indexPath)
//            (cell as? StatsTableViewCell)?.configure(with: pokemon.stats)
//        case 4:
//            cell = tableView.dequeueReusableCell(withIdentifier: "evolutionTree", for: indexPath)
//            if let evolutionChain = pokemon.fetchedEvolutionChain {
//                (cell as? EvolutionTreeTableViewCell)?.configure(with: evolutionChain)
//            }
//        default:
//            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = "CELL NOT CONFIGURED PROPERLY"
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
