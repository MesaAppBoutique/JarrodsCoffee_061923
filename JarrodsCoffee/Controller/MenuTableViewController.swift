//
//  MenuTableViewController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//  Modified by David Levy on 8/7/23.

import UIKit
import Firebase

class MenuTableViewController: UITableViewController {
    //category name from CategoryViewController
    var category: String!
    
    //array of menuItems
    //var menuItems = [MenuItem]()
    
    //we need to listen for changes to the Firestore database
    //let db = Firestore.firestore()
    //let listener: ListenerRegistration? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuController.shared.downloadImagesFromCloud()
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
        
        
        // Table title is capitalized category name
        title = category.capitalized
                
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
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI(with: MenuItem.allItems)
    }
    
    /// Set the property and update the interface
    func updateUI(with menuItems: [MenuItem]) {
        // have to go back to main queue from background queue where network requests are executed
        DispatchQueue.main.async {
            // remember the menu items for diplaying in the table
            MenuItem.allItems = menuItems
            
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
        return MenuItem.allItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuse the menu list prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)

        // configure the cell with menu list data
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // get the needed menu item for corresponding table row
        var menuItem = MenuItem.allItems[indexPath.row]
        
        // the left label of the cell should display the name of the item
        cell.textLabel?.text = menuItem.name
        DispatchQueue.main.async  {
            cell.imageView?.image = MenuController.shared.assignImage(path: menuItem.imageURL)
        }
    }
    
    // adjust the cell height to make images look better
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    /// Passes MenuItem to MenuItemDetailViewController before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // checks this segue is from MenuTableViewController to MenuItemDetailViewController
        if segue.identifier == "MenuDetailSegue" {
            // we can safely downcast to MenuItemDetailViewController
            let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
            
            // selected cell's row is the index for array of menuItems
            let index = tableView.indexPathForSelectedRow!.row
            
            // pass selected menuItem to destination MenuItemDetailViewController
            menuItemDetailViewController.menuItem = MenuItem.allItems[index]
        }
    }

}

