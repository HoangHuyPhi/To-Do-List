//
//  DataModel.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 5/12/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import Foundation
class DataModel {
    var categories = [CategoriesModel]()
    var indexOfSelectedCategory: Int {
        get {
            return UserDefaults.standard.integer(forKey: "categoriesIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "categoriesIndex")
        }
    }
    init() {
        loadChecklistItems()
        registerDefaults()
        handleFirstTime()
    }
    // Create a file to store data on device
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    // Save data to a file
    func saveChecklistItem() {
        // 1
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(categories)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    // Load data to a file
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                categories = try decoder.decode([CategoriesModel].self, from: data)
            } catch {
                print("Error coding item array!")
            }
        }
    }
    func registerDefaults() {
        let dictionary = ["categoriesIndex" : -1, "FirstTime" : true] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let category = CategoriesModel(name: "Category")
            categories.append(category)
            indexOfSelectedCategory = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    func sort() {
        categories.sort { (category1, category2) -> Bool in
            return category1.name.localizedStandardCompare(category2.name) == .orderedAscending
        }
    }
    class func nextCheckListItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}
