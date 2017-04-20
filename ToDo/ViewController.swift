//
//  ViewController.swift
//  ToDo
//
//  Created by Bart Jacobs on 20/04/2017.
//  Copyright © 2017 Envato Tuts+. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddItemViewControllerDelegate {

    @IBOutlet var tableView: UITableView!

    var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Title
        title = "To Do"

        // Populate Items
        items = ["Buy Milk", "Finish Tutorial", "Play Minecraft"]

        // Register Class for Cell Reuse
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemViewController" {
            let navigationController = segue.destination as? UINavigationController
            let addItemViewController = navigationController?.topViewController as? AddItemViewController

            if let viewController = addItemViewController {
                viewController.delegate = self
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch Item
        let item = items[indexPath.row]

        // Dequeue Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)

        // Configure Cell
        cell.textLabel?.text = item
        
        return cell
    }

    // MARK: Add Item View Controller Delegate Methods

    func controller(_ controller: AddItemViewController, didAddItem: String) {
        // Update Data Source
        items.append(didAddItem)

        // Reload Table View
        tableView.reloadData()

        // Dismiss Add Item View Controller
        dismiss(animated: true)
    }

}
