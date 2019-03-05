//
//  ItemModel.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 3/4/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import Foundation
class ItemModel {
    var ischecked = false
    var itemName = ""
}
extension ItemModel {
    func toggleItemChecked() {
        ischecked = !ischecked
    }
}

