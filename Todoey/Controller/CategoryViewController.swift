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

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categoryarray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryarray?[indexPath.row].name ?? "No Category"
        
        return cell
    }
    
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
