//
//  SwiptTableViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw Lay on 15/10/18.
//  Copyright © 2018 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive,title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)

        }
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            self.editModel(at: indexPath)
        }
        // customize the action appearance
        //deleteAction.image = UIImage(named: "Trash-Icon")
        
        return [deleteAction,editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        options.transitionStyle = .border
        return options
    }
    
    func editModel(at indexPath: IndexPath){
        //edit Model
    }
    
    func updateModel(at indexPath: IndexPath){
        //update dataModel
    }
    
}

