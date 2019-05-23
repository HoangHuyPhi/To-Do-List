//
//  File.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 5/11/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import UIKit

protocol AddAndEditCategoriesViewControllerDelegate: class {
    func AddAndEditCategoriesViewControllerDidCancel(_ controller: AddAndEditCategoriesViewController)
    func AddAndEditCategoriesViewController(_ controller: AddAndEditCategoriesViewController,
                                            didFinishAdding categories: CategoriesModel)
    func AddAndEditCategoriesViewController(_ controller: AddAndEditCategoriesViewController, didFinishEditing categories: CategoriesModel)
}

class AddAndEditCategoriesViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    var iconName = "Folder"
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate: AddAndEditCategoriesViewControllerDelegate?
    var categoriesToEdit: CategoriesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let categories = categoriesToEdit {
            title = "Edit Checklist"
            textField.text = categories.name
            doneBarButton.isEnabled = true
            iconName = categories.iconName
        }
        iconImageView.image = UIImage(named: iconName)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    // Mark:- Actions
    @IBAction func cancel() {
        delegate?.AddAndEditCategoriesViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let category = categoriesToEdit {
            category.name = textField.text!
            category.iconName = iconName
            delegate?.AddAndEditCategoriesViewController(self, didFinishEditing: category)
        } else {
            let category = CategoriesModel(name: textField.text!, iconName: iconName)
            category.iconName = iconName
            delegate?.AddAndEditCategoriesViewController(self, didFinishAdding: category)
        }
    }
    // Mark:- TableView Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    // Mark:- UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    // MARK:- Icon Picker View Controller Delegate
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
}
