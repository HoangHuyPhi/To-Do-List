//
//  ViewController.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 2/28/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {
    var itemsArray: [ItemModel]
    // Initialize itemsArray
    required init?(coder aDecoder: NSCoder) {
        itemsArray = [ItemModel]()
        let item1 = ItemModel()
        item1.itemName = "Huy Dep trai 1"
        item1.ischecked = true
        let item2 = ItemModel()
        item2.itemName = "Huy Dep trai 2"
        item2.ischecked = false
        let item3 = ItemModel()
        item3.itemName = "Huy Dep trai 3"
        item3.ischecked = true
        let item4 = ItemModel()
        item4.itemName = "Huy Dep trai 4"
        item4.ischecked = true
        let item5 = ItemModel()
        item5.itemName = "Huy Dep trai 5"
        item5.ischecked = true
        itemsArray.append(item1)
        itemsArray.append(item2)
        itemsArray.append(item3)
        itemsArray.append(item4)
        itemsArray.append(item5)
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellList", for: indexPath)
        let item = itemsArray[indexPath.row]
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.itemName
        configureCheckMark(for: cell, at: indexPath)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = itemsArray[indexPath.row]
            item.toggleItemChecked()
            configureCheckMark(for: cell, at: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func configureCheckMark(for cell: UITableViewCell,at indexPath: IndexPath) {
         let item = itemsArray[indexPath.row]
         cell.accessoryType = item.ischecked == false ?.none : .checkmark
    }
}

