//
//  ListPreviewTableViewCell.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import Foundation
import UIKit

class ListPreviewTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
