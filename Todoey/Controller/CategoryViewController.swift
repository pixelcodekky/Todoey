//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 13/10/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categoryarray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.rowHeight = 70.00
        //tableView.separatorStyle = .none
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (category) in
            let newCat = Category()
            newCat.name = textField.text!
            //newCat.color = UIColor.randomFlat.hexValue()
            newCat.color = FlatWhite().hexValue()
            self.save(category: newCat)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addTextField { (text) in
            text.placeholder = "Add New Category"
            textField = text
        }
        alert.addAction(action)
        alert.addAction(actionCancel)
        present(alert,animated: true,completion: nil)
        
    }
    
    //MARK: - table View Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryarray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryarray?[indexPath.row]{
            cell.textLabel?.text = category.name
            //cell.backgroundColor = UIColor.randomFlat
            cell.backgroundColor = UIColor(hexString: category.color )
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color)!, returnFlat: true)
        }
        
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
    
    func edit(index : IndexPath,name : UITextField){
        if let item = categoryarray?[index.row]{
            do{
                try realm.write {
                    item.name = name.text!;
                }
            }catch{
                print("Error occur while updating \(error )")
            }
        }
        tableView.reloadData()
    }
    
    func loadData(){
        categoryarray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    //MARK - Delete Data call function from delegate class
    override func updateModel(at indexPath: IndexPath) {
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
    
    //MARK - Edit Data cell function from delegate class
    override func editModel(at indexPath: IndexPath) {
        //call UIAlertController
        var textField = UITextField()
        if let editcategory = self.categoryarray?[indexPath.row]{
            let alert = UIAlertController(title: "Edit \(editcategory.name)", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Edit Category", style: .default) { (edit) in
                self.edit(index: indexPath ,name : textField)
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addTextField { (text) in
                text.text = editcategory.name
                textField = text
            }
            alert.addAction(action)
            alert.addAction(actionCancel)
            present(alert,animated: true,completion: nil)
        }
    }
    
}
