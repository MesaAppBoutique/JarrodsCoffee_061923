//
//  MenuTableViewController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//  Modified by David Levy on 8/7/23.

import UIKit
import Firebase

class MenuItemsTableVC: UITableViewController {
    //category name from CategoryViewController
    var showName: String = ""
    var showItems: [MenuItem] = []
    var unassignedItems: [MenuItem] = []
    //array of menuItems
    //var menuItems = [MenuItem]()
    
    //we need to listen for changes to the Firestore database
    //let db = Firestore.firestore()
    //let listener: ListenerRegistration? = nil
    @IBOutlet weak var addItemButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        //MenuController.shared.downloadImagesFromCloud()
//        db.collection("menuItems").addSnapshotListener { (snapshot, error) in
//            switch (snapshot, error) {
//            case (.none, .none):
//                print("no data")
//            case (.none, .some(let error)):
//                print("some error \(error.localizedDescription)")
//            case (.some(let snapshot), _):
//                print("collection updated, now it contains \(snapshot.documents.count) documents")
//            }
//        }
        
        //fetch data and update views
        
        //Enable nav bar
        self.navigationController?.isNavigationBarHidden = false
        // Table title is capitalized category name
        title = showName.capitalized
                
//        // Load the menu for a given category
//        MenuController.shared.fetchMenuItems(categoryName: category) { (menuItems) in
//            // if we indeed got the menu items
//
//            if let menuItems = menuItems {
//                // update the interface
//                self.updateUI(with: menuItems)
//            }
//        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        //if the admin is logged in then show the edit and add button
        // adjusting the nav bar items in viewWillAppear or viewDidAppear or it wont trigger since the bar hasn't been rendered until after viewDidLoad
        
        if AppData.shared.isAdminLoggedIn {
            self.navigationItem.rightBarButtonItems = [self.addItemButton, self.editButtonItem]
        } else {
            self.navigationItem.rightBarButtonItems = []
        }
    }
    
    /// Set the property and update the interface
    func updateUI(with menuItems: [MenuItem]) {
        // have to go back to main queue from background queue where network requests are executed
        DispatchQueue.main.async {
            // remember the menu items for diplaying in the table
            self.showItems = menuItems
            
            // reload the table
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // there is only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of cells is equal to the size of menu items array
        return showItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuse the menu list prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)

        // configure the cell with menu list data
        let menuItem = showItems[indexPath.row]
        
        // the left label of the cell should display the name of the item
        cell.textLabel?.text = menuItem.name

        DispatchQueue.main.async  {
            //cell.imageView?.image = AppData.shared.assignImage(withKey: menuItem.imageURL)
            cell.imageView?.image = menuItem.image
            //cell.imageView?.image = AppData.shared.assignImage(withKey: menuItem.imageURL)
            cell.setNeedsLayout() // adding this fixes the image resizing when clicked
            //self.fitImage(in: cell)

        }
        
        return cell
    }
    
    
    // adjust the cell height to make images look better
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)

          performSegue(withIdentifier: "showDetails", sender: indexPath)
        
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let editItemVC = segue.destination as! ItemDetailsVC
            if let indexPath = sender as? IndexPath {
                editItemVC.menuItem = showItems[indexPath.row]
            }
        }
    }

    
}

