//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 13/10/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryarray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (category) in
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            self.categoryarray.append(newCat)
            self.saveData()
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
        return categoryarray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryarray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = self.categoryarray[index.row]
        }
        
        
    }
    
    //MARK: - Data manupilation
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error occur while saving \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            try categoryarray = context.fetch(request)
        }catch{
            print("Error occur when fetch \(error)")
        }
        
        
    }
}
