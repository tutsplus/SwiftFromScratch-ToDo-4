//
//  ViewController.swift
//  ToDo
//
//  Created by Bart Jacobs on 20/04/2017.
//  Copyright © 2017 Envato Tuts+. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddItemViewControllerDelegate {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    var items: [String] = [] {
        didSet(oldValue) {
            let hasItems = items.count > 0
            tableView.isHidden = !hasItems
            messageLabel.isHidden = hasItems
        }
    }

    var checkedItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Title
        title = "To Do"

        // Populate Items
        items = ["Buy Milk", "Finish Tutorial", "Play Minecraft"]

        // Load State
        loadItems()
        loadCheckedItems()

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

    // MARK: - Table View Data Source Methods

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

        if checkedItems.contains(item) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Item
            let item = items[indexPath.row]

            // Update Items
            items.remove(at: indexPath.row)

            if let index = checkedItems.index(of: item) {
                checkedItems.remove(at: index)
            }

            // Update Table View
            tableView.deleteRows(at: [indexPath], with: .right)

            // Save State
            saveItems()
            saveCheckedItems()
        }
    }

    // MARK: - Table View Delegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Fetch Item
        let item = items[indexPath.row]

        // Fetch Cell
        let cell = tableView.cellForRow(at: indexPath)

        // Find Index of Item
        let index = checkedItems.index(of: item)

        if let index = index {
            checkedItems.remove(at: index)
            cell?.accessoryType = .none
        } else {
            checkedItems.append(item)
            cell?.accessoryType = .checkmark
        }

        // Save State
        saveCheckedItems()
    }

    // MARK: Add Item View Controller Delegate Methods

    func controller(_ controller: AddItemViewController, didAddItem: String) {
        // Update Data Source
        items.append(didAddItem)

        // Save State
        saveItems()

        // Reload Table View
        tableView.reloadData()

        // Dismiss Add Item View Controller
        dismiss(animated: true)
    }

    // MARK: Private Helper Methods

    private func loadItems() {
        let userDefaults = UserDefaults.standard

        if let items = userDefaults.object(forKey: "items") as? [String] {
            self.items = items
        }
    }

    private func loadCheckedItems() {
        let userDefaults = UserDefaults.standard

        if let checkedItems = userDefaults.object(forKey: "checkedItems") as? [String] {
            self.checkedItems = checkedItems
        }
    }

    // MARK: -

    private func saveItems() {
        let userDefaults = UserDefaults.standard

        // Update User Defaults
        userDefaults.set(items, forKey: "items")
        userDefaults.synchronize()
    }

    private func saveCheckedItems() {
        let userDefaults = UserDefaults.standard

        // Update User Defaults
        userDefaults.set(checkedItems, forKey: "checkedItems")
        userDefaults.synchronize()
    }

}
