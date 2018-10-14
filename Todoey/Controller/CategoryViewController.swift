//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 13/10/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categoryarray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.rowHeight = 70.00
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (category) in
            let newCat = Category()
            newCat.name = textField.text!
            self.save(category: newCat)
        }
        
        alert.addTextField { (text) in
            text.placeholder = "Add New Category"
            textField = text
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
    }
    
    //MARK: - table View Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryarray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate  = self
        cell.textLabel?.text = categoryarray?[indexPath.row].name ?? "No Category"
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    //MARK: - table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = self.categoryarray?[index.row]
        }
    }
    
    //MARK: - Data manupilation
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error occur while saving \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        categoryarray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
}

//MARK - Swipt cell delegate method

extension CategoryViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive,title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //print("\(self.categoryarray?[indexPath.row].name) has been deleted.")
            if let deletecategory = self.categoryarray?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(deletecategory)
                    }
                }catch{
                    print("Error occur while delete")
                }
            }
        }
        
        // customize the action appearance
        //deleteAction.image = UIImage(named: "Trash-Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
