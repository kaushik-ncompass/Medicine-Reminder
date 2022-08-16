//
//  BaseCell.swift
//  Medicine Remainder
//
//  Created by Kaushik on 16/08/22.
//

import UIKit

class BaseCell: UITableViewCell {
    var row: UserRow!
    var indexPath: IndexPath!
    weak var owner: ViewController!
    
    func configureCellFor(row: UserRow, owner: ViewController, indexPath: IndexPath) {
        self.row = row
        self.indexPath = indexPath
        self.owner = owner
    }
}
