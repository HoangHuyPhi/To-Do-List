//
//  AddItemListViewController.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 3/5/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import UIKit
class AddItemListViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    override func viewDidLoad() {
         super.viewDidLoad()
         navigationController?.navigationBar.prefersLargeTitles = false
         addItemTextField.becomeFirstResponder()
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    @IBAction func Done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        print(addItemTextField.text!)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    // Validate user's input in text field
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
}
