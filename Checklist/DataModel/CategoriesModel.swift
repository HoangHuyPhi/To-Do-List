//
//  CategoriesModel.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 5/11/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import UIKit

class CategoriesModel: NSObject, Codable {
    var name = ""
    var iconName = "No icon"
    var items = [ItemModel]()
    init(name: String, iconName: String = "No icon") {
        self.iconName = iconName
        self.name = name
        super.init()
    }
    func countUnCheckedItems() -> Int {
        var count = 0
        for item in items where !item.ischecked {
            count += 1
        }
        return count
    }
}
