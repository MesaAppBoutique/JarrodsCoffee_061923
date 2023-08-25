//
//  CateogryTableViewController.swift
//  JarrodsCoffee
//
//  Created by David Levy on 8/8/23.
//

import UIKit

class CategoriesVC: UITableViewController {

    
    var categoryId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        //Enable nav bar
        self.navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuItem.shared.categories.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        let categoryId = MenuItem.shared.categories[indexPath.row].id
        let category = MenuCategory.shared.loadCategory(withId: categoryId)
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = category.imageURL
        cell.imageView?.image = category.image
        
        return cell
    }
  

   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  

 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let category = MenuItem.shared.categories[indexPath.row].name
            
            MenuItem.shared.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AppData.shared.removeReference(to: category)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryId = MenuItem.shared.categories[indexPath.row].id
    }
    
    /// Passes MenuItem to MenuItemDetailViewController before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // checks this segue is from MenuTableViewController to MenuItemDetailViewController
        if segue.identifier == "EditCatSegue" {
            // we can safely downcast to MenuItemDetailViewController
            let edit = segue.destination as! EditCategoryVC
            
            
            let category = MenuCategory.shared.loadCategory(withId: categoryId ?? UUID().uuidString)
            // selected cell's row is the index for array of menuItems
//            let index = tableView.indexPathForSelectedRow!.row
            
            // pass selected menuItem to destination MenuItemDetailViewController
            edit.categoryId = category.id
            edit.categoryName = category.name
           // edit.categoryOutlet.text = category.name
        }
    }
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

   

}
