//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by csuftitan on 5/3/23.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    var itemsUnder50: [Item] {
        return itemStore.allItems.filter { $0.valueInDollars < 50}
    }
    
    var itemsAbove50: [Item] {
        return itemStore.allItems.filter { $0.valueInDollars >= 50}
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {
        // Create a new item and add it to the store
           let newItem = itemStore.createItem()

           let section = newItem.valueInDollars < 50 ? 0 : 1

           // Figure out where that item is in the array
            if let index = (section == 0 ? itemsUnder50 : itemsAbove50).firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: section)

               // Insert this new row into the table
               tableView.insertRows(at: [indexPath], with: .automatic)
           }
      }

    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently in editing mode...
            if isEditing {
                // Change text of button to inform user of state
                sender.setTitle("Edit", for: .normal)

                // Turn off editing mode
                setEditing(false, animated: true)
            } else {
                // Change text of button to inform user of state
                sender.setTitle("Done", for: .normal)

                // Enter editing mode
                setEditing(true, animated: true)
            }

      }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var a:Int! = nil
        print(a)

        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
        
        override func tableView(_ tableView: UITableView,
                numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return itemsUnder50.count
            } else {
                return itemsAbove50.count
            }
    }
    
    override func tableView(_ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",
                                                     for: indexPath) as! ItemCell

        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the table view
        let item: Item
        
        if indexPath.section == 0 {
            item = itemsUnder50[indexPath.row]
        } else {
            item = itemsAbove50[indexPath.row]
        }

        // Configure the cell with the Item
        cell.configure(with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = indexPath.section == 0 ? itemsUnder50[indexPath.row] : itemsAbove50[indexPath.row]

            // Remove the item from the store
            itemStore.removeItem(item)

            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Items under $50"
        } else {
            return "Items $50 and above"
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem":
            // Figure out which row was just tapped
            if let indexPath = tableView.indexPathForSelectedRow {

                // Get the item associated with this row and pass it along
                let item = indexPath.section == 0 ? itemsUnder50[indexPath.row] : itemsAbove50[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
