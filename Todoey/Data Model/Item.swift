//
//  Item.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 14/10/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var createdDate : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
