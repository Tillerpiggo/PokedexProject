//
//  MoveListViewController.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import UIKit

class MoveListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var moves: [MoveEntry]
    private var version: String?
    private let moveLearnMethods = [
        "level-up",
        "egg",
        "tutor",
        "machine",
        "stadium-surfing-pikachu",
        "light-ball-egg",
        "colosseum-purification",
        "xd-shadow",
        "xd-purification",
        "form-change",
        "zygarde-cube",
    ]
    
    private var presentMoveLearnMethods: [String] {
        return moveLearnMethods.filter {
            moves(for: $0).count > 0
        }
    }
    
    private var presentVersions: [String] {
        var versions: [String] = []
        var seen = Set<String>()
        for move in moves {
            for versionGroupDetail in move.version_group_details {
                let version = versionGroupDetail.version_group.name
                if !seen.contains(versionGroupDetail.version_group.name) {
                    versions.append(version)
                }
                seen.insert(version)
            }
        }
        
        return versions
    }
    
    private let tableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(moves: [MoveEntry]) {
        self.moves = moves
        super.init(nibName: nil, bundle: nil)
        self.version = presentVersions.first
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: version?.parsingHyphens(), style: .plain, target: self, action: nil)
        
        let menu = UIMenu(title: "", children: presentVersions.compactMap { [weak self] version in
            guard let self = self else { return nil }
            return UIAction(title: version.parsingHyphens()) { [weak self] _ in
                self?.version = version
                self?.navigationItem.rightBarButtonItem?.title = version.parsingHyphens()
                self?.tableView.reloadData()
            }
        })
        
        navigationItem.rightBarButtonItem?.menu = menu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        addConstraints()
        title = "Moves"
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
    
    private func moves(for moveLearnMethod: String) -> [MoveEntry] {
        guard let version = version else { return [] }
        
        return moves.filter { move in
            guard let versionGroupDetail = move.version_group_details.first(where: { $0.version_group.name == version }) else {
                return false
            }
            return versionGroupDetail.move_learn_method.name == moveLearnMethod
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moves(for: presentMoveLearnMethods[section]).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presentMoveLearnMethods.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presentMoveLearnMethods[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movesForIndexPath = moves(for: presentMoveLearnMethods[indexPath.section])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let moveEntry = movesForIndexPath[indexPath.row]
        cell.textLabel?.text = moveEntry.move.name.parsingHyphens()
        return cell
    }
}
