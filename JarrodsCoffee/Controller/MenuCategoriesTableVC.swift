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
        if AppData.shared.isAdminLoggedIn {
           return true
        } else {
            return false
        }
    }

    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if AppData.shared.isAdminLoggedIn {
           return true
        } else {
            return false
        }
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
        
        //This lets the owner edit the categories if logged in
        let modifyOption = UIContextualAction(style: .normal, title: "Modify") {  (contextualAction, view, success) in

            AppData.shared.selectedCategory = self.categories[indexPath.row]
            //Janky but this way we're not passing data around in strange ways

            OperationQueue.main.addOperation {
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "EditCategory") as! EditCategoryVC
               self.present(newViewController, animated: true, completion: nil)
                success(true)
            }
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
                let filteredMenuItems = AppData.shared.menuFiltered(by: category.id, fromItems: MenuItem.allItems)
                menuVC.showItems = filteredMenuItems
                menuVC.showName =  category.name
            }
        }
        
        if segue.identifier == "UnassignedSegue" {
 
            if let menuVC = segue.destination as?
                MenuItemsTableVC {
                let index = tableView.indexPathForSelectedRow!.row
                let filteredMenuItems = AppData.shared.menuFiltered(by: MenuItem.categories[index].id, fromItems: MenuItem.allItems)
                menuVC.showItems = filteredMenuItems
                menuVC.showName = MenuItem.categories[index].name
            }
        }
        
        if segue.identifier == "FromMenuToAddCategory" {
            //If they are going to add a new category
            //Create an empty selectedCategory before the view dismisses
            AppData.shared.selectedCategory = MenuCategory(id:UUID().uuidString)
        }
    
        
    }
 
}

