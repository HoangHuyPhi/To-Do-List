//
//  AddItemListViewController.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 3/5/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import UIKit
import UserNotifications
protocol AddAndEditItemViewControllerDelegate: class {
    func AddAndEditViewControllerDidCancel(_ controller: AddAndEditItemViewController)
    func AddAndEditViewController(_ controller: AddAndEditItemViewController, didFinishAdding item: ItemModel)
    func AddAndEditViewControllerDidFinishEditing(_ controller: AddAndEditItemViewController, didFinishEditing item: ItemModel)
}
class AddAndEditItemViewController: UITableViewController, UITextFieldDelegate {
    weak var Delegate: CheckListViewController?
    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dueDate = Date()
    var datePickerVisible = false
    var itemToEdit: ItemModel?
    
    override func viewDidLoad() {
         super.viewDidLoad()
         navigationController?.navigationBar.prefersLargeTitles = false
         addItemTextField.becomeFirstResponder()
        if let item = itemToEdit {
            title = "Edit Item"
            addItemTextField.text = item.itemName
            doneButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    // MARK: TableView Data Source's methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addItemTextField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
}

extension AddAndEditItemViewController {
    @IBAction func Done(_ sender: Any) {
        if let item = itemToEdit {
            item.itemName = addItemTextField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            Delegate?.AddAndEditViewControllerDidFinishEditing(self, didFinishEditing: item)
        } else {
            let item = ItemModel()
            item.ischecked = false
            item.itemName = addItemTextField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            Delegate?.AddAndEditViewController(self, didFinishAdding: item)
        }
    }
    @IBAction func Cancel(_ sender: Any) {
        Delegate?.AddAndEditViewControllerDidCancel(self)
    }
    //MARK:- Validate user's input in text field
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    //MARK:- Due date's methods
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        datePicker.setDate(dueDate, animated: false)
    }
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor.black
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        addItemTextField.resignFirstResponder()
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in
                // do nothing
            }
        }
    }
}
