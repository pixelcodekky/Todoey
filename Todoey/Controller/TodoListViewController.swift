//
//  ViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 29/9/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
 
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectCategory : Category? {
        didSet{
            loadData()
        }
    }
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var userDefault = UserDefaults.standard
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //tableView.separatorStyle = .none
        //self.tableView.isEditing = true
     }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectCategory!.name
        guard let color = selectCategory?.color else {fatalError("Model doesn't have data.")}
        updateNavBarwithColor(hexColor: color)
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBarwithColor(hexColor: "1D9BF6")
    }
    
    //MARK: - update nav bar
    func updateNavBarwithColor(hexColor : String){
        guard let  validNavbar = navigationController?.navigationBar else {fatalError("Navigation doesn't exists.")}
        guard let navColor = UIColor(hexString: hexColor) else{fatalError("")}
        validNavbar.tintColor = ContrastColorOf(navColor, returnFlat: true)
        //validNavbar.barTintColor = navColor
        //searchBar.barTintColor = navColor
        validNavbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navColor, returnFlat: true)]
        
    }
    
    //MARK: - Table View Datasource method
    //total cell for ITem View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
//            if let color = UIColor(hexString: selectCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
//                cell.backgroundColor = color
//                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
//            }
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }

    //MARK: - Table View Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error occur while updating \(error )")
            }
        }
        tableView.reloadData()
 
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        saveData()
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let title = "Create new " + (selectCategory?.name)! + " Item"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when click add item button upon on this
            do{
                if let currentCat = self.selectCategory{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.createdDate = Date()
                        currentCat.items.append(newItem)
                    }
                }
            }catch{
                print("Error occur while saving to Realm \(error)")
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Text"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveData(){
        self.tableView.reloadData()
    }
    
    //edit Data
    func edit(index : IndexPath,name : UITextField){
        if let item = todoItems?[index.row]{
            do{
                try realm.write {
                    item.title = name.text!
                }
            }catch{
                print("\(error)")
            }
            tableView.reloadData()
        }
    }
    
    func loadData(){
        todoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Error Occru while deleting \(error)")
            }
        }
    }
    
    override func editModel(at indexPath: IndexPath) {
        var textFiled = UITextField()
        if let items = todoItems?[indexPath.row]{
            let alert = UIAlertController(title: "Edit \(items.title)", message: nil, preferredStyle: .alert)
            alert.addTextField{ (text) in
                text.text = items.title
                textFiled = text
            }
            let editaction = UIAlertAction(title: "Edit", style: .default) { (edit) in
                self.edit(index: indexPath, name: textFiled)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(editaction)
            alert.addAction(cancel)
            present(alert,animated: true,completion: nil)
            
        }
    }
    
}
//MARK: Search Bar Method Implement
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
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

