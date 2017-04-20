//
//  AddItemViewController.swift
//  ToDo
//
//  Created by Bart Jacobs on 20/04/2017.
//  Copyright © 2017 Envato Tuts+. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate {

    func controller(_ controller: AddItemViewController, didAddItem: ToDo)
    
}

class AddItemViewController: UIViewController {

    @IBOutlet var textField: UITextField!

    var delegate: AddItemViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func create(_ sender: Any) {
        if let name = textField.text {
            // Create Item
            let item = ToDo(name: name, done: false)

            // Notify Delegate
            delegate?.controller(self, didAddItem: item)
        }
    }

}
