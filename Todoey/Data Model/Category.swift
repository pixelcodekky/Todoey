//
//  Category.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 14/10/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
