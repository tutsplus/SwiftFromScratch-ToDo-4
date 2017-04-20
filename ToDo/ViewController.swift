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

    var items: [ToDo] = [] {
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

        // Load State
        loadItems()

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
        cell.textLabel?.text = item.name
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Update Items
            items.remove(at: indexPath.row)

            // Update Table View
            tableView.deleteRows(at: [indexPath], with: .right)

            // Save State
            saveItems()
        }
    }

    // MARK: - Table View Delegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Fetch Item
        let item = items[indexPath.row]

        // Update Item
        item.done = !item.done

        // Fetch Cell
        let cell = tableView.cellForRow(at: indexPath)

        // Update Cell
        cell?.accessoryType = item.done ? .checkmark : .none

        // Save State
        saveItems()
    }

    // MARK: Add Item View Controller Delegate Methods

    func controller(_ controller: AddItemViewController, didAddItem: ToDo) {
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
        let path = pathForItems()

        if let items = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [ToDo] {
            self.items = items
        }
    }

    // MARK: -

    private func saveItems() {
        let path = pathForItems()

        if NSKeyedArchiver.archiveRootObject(self.items, toFile: path) {
            print("Successfully Saved")
        } else {
            print("Saving Failed")
        }
    }

    // MARK: -

    private func pathForItems() -> String {
        guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
              let url = URL(string: documentsDirectory) else {
            fatalError("Documents Directory Not Found")
        }

        return url.appendingPathComponent("items").path
    }

}
