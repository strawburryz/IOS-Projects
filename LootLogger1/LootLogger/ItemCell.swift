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
    
    // Method to set text and color of the labels / items
    func configure(with item: Item) {
        nameLabel.text = item.name
        serialNumberLabel.text = item.serialNumber
        valueLabel.text = "$\(item.valueInDollars)"

        if item.valueInDollars < 50 {
            valueLabel.textColor = .blue
        } else {
            valueLabel.textColor = .red
        }
    }
}
