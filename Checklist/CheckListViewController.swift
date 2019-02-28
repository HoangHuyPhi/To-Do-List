//
//  ViewController.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 2/28/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellList", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        if indexPath.row % 5 == 0 {
            label.text = "Huy Dep Trai1"
        }
        else if indexPath.row % 5 == 1 {
            label.text = "Huy Dep Trai2"
        }
        else if indexPath.row % 5 == 2 {
            label.text = "Huy Dep Tra3i"
        }
        else if indexPath.row % 5 == 3 {
            label.text = "Huy Dep Trai4"
        }
        else if indexPath.row % 5 == 4 {
            label.text = "Huy Dep Trai5"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = cell.accessoryType == .checkmark ?.none : .checkmark
        }
    }
}

