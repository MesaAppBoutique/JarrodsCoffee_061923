//
//  CategoryTableViewController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//  Modified by David Levy on 8/7/23.

import UIKit
import SwiftUI

class MenuCategoriesTableVC: UITableViewController {
    
    var categories = [MenuCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppData.shared.fetchCategoryData { fetched in
            self.categories = fetched
            self.updateUI(with: fetched)
        }
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)

        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name

        DispatchQueue.main.async {
            cell.imageView?.image = AppData.shared.assignImage(withKey: category.imageURL)
            self.fitImage(in: cell)
        }
        
        return cell
    }
    
    
    func updateUI(with categories: [MenuCategory]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let renameAction = UITableViewRowAction(style: .normal, title: "Rename") { action, indexPath in
            
            //Present a text field
            
            //Udpate data
            
            //Refresh view
            
            //Push changes to cloud

            print("UPDATE CAT NAME!")
            
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            
            
            //Delete category locally
            
            //Refresh view
            
            //Delete category from cloud

            print("DELETE CAT NAME!")
            
            
        }
        return [ deleteAction, renameAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        
        
        if segue.identifier == "MenuSegue" {
            if let menuVC = segue.destination as?
                MenuItemsTableVC {
                let index = tableView.indexPathForSelectedRow!.row
                let category = categories[index]
                let filteredMenuItems = AppData.shared.menuFiltered(by: category.id, fromItems: MenuItem.shared.allItems)
                menuVC.showItems = filteredMenuItems
                menuVC.showName =  category.name
            }
        }
        
        if segue.identifier == "UnassignedSegue" {
 
            if let menuVC = segue.destination as?
                MenuItemsTableVC {
                let index = tableView.indexPathForSelectedRow!.row
                let filteredMenuItems = AppData.shared.menuFiltered(by: MenuItem.shared.categories[index].id, fromItems: MenuItem.shared.allItems)
                menuVC.showItems = filteredMenuItems
                menuVC.showName = MenuItem.shared.categories[index].name
            }
        }
    }
 
}

