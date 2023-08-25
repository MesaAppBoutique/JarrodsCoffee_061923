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
    @IBOutlet weak var addCatButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppData.shared.fetchCategoryData { fetched in
            self.categories = fetched
            self.updateUI(with: fetched)
        }
        //Enable nav bar is okay here
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //if the admin is logged in then show the edit and add button
        // adjusting the nav bar items in viewWillAppear or viewDidAppear or it wont trigger since the bar hasn't been rendered until after viewDidLoad
        
        if AppData.shared.isAdminLoggedIn {
            self.navigationItem.rightBarButtonItems = [self.addCatButton, self.editButtonItem]
        } else {
            self.navigationItem.rightBarButtonItems = []
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
        //The ViewDidLoad is where we are checking to see if the admin is logged in, not here.
        return true
    }

    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("WE LIKE TO MOVEIT MOVEIT!")
    }
    
    override func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        print("CONTEXT")
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteOption = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            print("BALETED!")
        }
        let modifyOption = UIContextualAction(style: .normal, title: "Modify") {  (contextualAction, view, boolValue) in
            print("MOFIDICO!")
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteOption, modifyOption])

        return swipeActions
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
        
        if segue.identifier == "EditCategories" {
            if let catVC = segue.destination as?
                CategoriesVC {
                //pre-load existing categories
                catVC.categories = categories
            }
        }
        
    }
 
}

