//
//  ItemCell.swift
//  LootLogger
//
//  Created by csuftitan on 5/3/23.
//

import UIKit

class ItemCell: UITableViewCell {
  
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    func configure(with item: Item) {
        nameLabel.text = item.name
        serialNumberLabel.text = item.serialNumber
        valueLabel.text = "$\(item.valueInDollars)"

        if item.valueInDollars < 50 {
            valueLabel.textColor = .systemGreen
        } else {
            valueLabel.textColor = .systemRed
        }
    }
    
}
