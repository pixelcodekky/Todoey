//
//  ViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 29/9/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
 
    //var itemArray = ["Main Story","The Things","Amend"]
    var itemArray = [Item]()
    var selectCategory : Category? {
        didSet{
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //loadData()
        //if let itemlist = userDefault.array(forKey: "ItemArrayList") as? [Item]{
        //    itemArray = itemlist
        //}
    }
    
    //MARK: - Table View Datasource method
    //total cell for ITem View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    
    //MARK: - Table View Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
 
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when click add item button upon on this
            
            
            let newitem = Item(context: self.context)
            newitem.title = textField.text!
            newitem.done = false
            newitem.parentCategory = self.selectCategory
            self.itemArray.append(newitem)
            //self.userDefault.set(self.itemArray, forKey: "ItemArrayList")
            self.saveData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Text"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveData(){
        
        do{
            try context.save()
        }catch{
            print("Error saving Context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicated : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
        
        if let extendPredicate = predicated{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,extendPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error requesting while fetch \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: Search Bar Method Implement
extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with : request,predicated : predicate)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

