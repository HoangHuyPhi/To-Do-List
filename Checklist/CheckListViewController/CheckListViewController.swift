//
//  ViewController.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 2/28/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, AddAndEditItemViewControllerDelegate {
    var categories: CategoriesModel!
    var itemsArray = [ItemModel]()
    // Initialize itemsArray
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.prefersLargeTitles = true
        title = categories.name
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellList", for: indexPath)
        let item = categories.items[indexPath.row]
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.itemName
        configureCheckMark(for: cell, at: item)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = categories.items[indexPath.row]
            item.toggleItemChecked()
            configureCheckMark(for: cell, at: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        categories.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    // Add Item's delegate methods
    func AddAndEditViewControllerDidCancel(_ controller: AddAndEditItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func AddAndEditViewController(_ controller: AddAndEditItemViewController, didFinishAdding item: ItemModel) {
        let newRowIndex = categories.items.count
        categories.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    func AddAndEditViewControllerDidFinishEditing(_ controller: AddAndEditItemViewController, didFinishEditing item: ItemModel) {
        if let index = categories.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = item.itemName
                configureCheckMark(for: cell, at: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }

    // End
    func configureCheckMark(for cell: UITableViewCell,at item: ItemModel) {
         let label = cell.viewWithTag(1001) as! UILabel
         label.text = item.ischecked == false ? "" : "🏁"
    }
    // Tell the AddItemListViewController to be its Delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddAndEditItemViewController
            controller.Delegate = self
        }
        if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddAndEditItemViewController
            controller.Delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = categories.items[indexPath.row]
            }
        }
    }
}

