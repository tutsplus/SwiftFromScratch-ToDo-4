//
//  ToDo.swift
//  ToDo
//
//  Created by Bart Jacobs on 20/04/2017.
//  Copyright © 2017 Envato Tuts+. All rights reserved.
//

import Foundation

class ToDo: Task {

    var done: Bool

    @objc required init?(coder aDecoder: NSCoder) {
        self.done = aDecoder.decodeBool(forKey: "done")
        super.init(coder: aDecoder)
    }

    @objc override func encode(with aCoder: NSCoder) {
        aCoder.encode(done, forKey: "done")
        super.encode(with: aCoder)
    }

    init(name: String, done: Bool) {
        self.done = done
        super.init(name: name)
    }

}
