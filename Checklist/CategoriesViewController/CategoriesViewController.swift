//
//  CategoriesViewController.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 5/11/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController, AddAndEditCategoriesViewControllerDelegate, UINavigationControllerDelegate {
    var dataModel: DataModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedCategory
        if index >= 0 && index < dataModel.categories.count {
            let category = dataModel.categories[index]
            performSegue(withIdentifier: "ShowCheckList", sender: category)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // Delegate method
    func AddAndEditCategoriesViewControllerDidCancel(_ controller: AddAndEditCategoriesViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func AddAndEditCategoriesViewController(_ controller: AddAndEditCategoriesViewController, didFinishAdding categories: CategoriesModel) {
        dataModel.categories.append(categories)
        dataModel.sort()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func AddAndEditCategoriesViewController(_ controller: AddAndEditCategoriesViewController, didFinishEditing categories: CategoriesModel) {
        dataModel.sort()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    // End
    // SAVE DATA IN USER DEFAULT
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedCategory = -1
        }
    }
    // End
    // Table View methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.categories.count
    }
    // Make cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        cell.textLabel!.text = dataModel.categories[indexPath.row].name
        let countUncheckItem = dataModel.categories[indexPath.row].countUnCheckedItems()
        if dataModel.categories.count == 0 {
            cell.detailTextLabel!.text = "No items"
        } else {
        cell.detailTextLabel!.text = countUncheckItem == 0 ? "All done" : "\(countUncheckItem) Remaining"
        }
        cell.accessoryType = .detailDisclosureButton
        cell.imageView!.image = UIImage(named: dataModel.categories[indexPath.row].iconName)
        return cell
    }
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    // end
    // Make segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedCategory = indexPath.row
        let checklist = dataModel.categories[indexPath.row]
        performSegue(withIdentifier: "ShowCheckList", sender: checklist)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.categories.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddAndEditCategoriesViewController") as! AddAndEditCategoriesViewController
        controller.delegate = self
        let category = dataModel.categories[indexPath.row]
        controller.categoriesToEdit = category
        navigationController?.pushViewController(controller, animated: true)
    }
    // END
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCheckList" {
            let controller = segue.destination as! CheckListViewController
            controller.categories = sender as? CategoriesModel
        }
        if segue.identifier == "AddCategory" {
            let controller = segue.destination as! AddAndEditCategoriesViewController
            controller.delegate = self
        }
    }
}

