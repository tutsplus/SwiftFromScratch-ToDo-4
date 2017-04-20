//
//  Task.swift
//  ToDo
//
//  Created by Bart Jacobs on 20/04/2017.
//  Copyright © 2017 Envato Tuts+. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {

    var name: String

    @objc required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
    }

    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }

    convenience override init() {
        self.init(name: "New Task")
    }

    init(name: String) {
        self.name = name
    }

}
