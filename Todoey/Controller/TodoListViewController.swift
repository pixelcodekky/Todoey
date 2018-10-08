//
//  ViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 29/9/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
 
    //var itemArray = ["Main Story","The Things","Amend"]
    var itemArray = [Item]()
    //var userDefault = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(dataFilePath!)
        
        loadData()
        
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
        
        cell.textLabel?.text = item.item
        
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
            let newitem = Item()
            newitem.item = textField.text!
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error Occur \(error)")
            }
            
            
        }
        
    }
    
}

