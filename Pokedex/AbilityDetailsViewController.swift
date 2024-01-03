//
//  AbilityDetailsViewController.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/24/23.
//

import Foundation
import UIKit

class AbilityDetailsViewController: UIViewController {
    
    private var dataLoader = DataLoader()
    private var abilityDetails: AbilityDetails?
    
    private var abilityDescription: String {
        guard let abilityDetails = abilityDetails else { return "Loading description..." }
        return abilityDetails.effect_entries.first(where: { $0.language.name == "en" })?.effect ?? "No English description found."
    }
    
    private var abilityName: String {
        guard let abilityDetails = abilityDetails else { return "" }
        return abilityDetails.names.first(where: { $0.language.name == "en" })?.name ?? ""
    }
    
    private let tableView = {
        let tableView = UITableView()
        tableView.register(MultilineTextTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ListPreviewTableViewCell.self, forCellReuseIdentifier: "listPreview")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(abilityURL: String) {
        super.init(nibName: nil, bundle: nil)
        DataLoader.loadData(urlString: abilityURL) { [weak self] (result: Result<AbilityDetails, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedAbilityDetails):
                abilityDetails = fetchedAbilityDetails
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    title = abilityName
                    tableView.reloadData()
                }
            case .failure(let error):
                print("ERROR fetching ability details: \(error)")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    private func addConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension AbilityDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = abilityDescription
            cell.accessoryType = .none
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "listPreview", for: indexPath)
            cell.textLabel?.text = "More with this ability"
            cell.detailTextLabel?.text = "\(abilityDetails?.pokemon.count ?? 0)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Description"
        case 1:
            return "Pokémon with this ability"
        default:
            return "??"
        }
    }
}
