//
//  CateogryTableViewController.swift
//  JarrodsCoffee
//
//  Created by David Levy on 8/8/23.
//

import UIKit

class CategoriesVC: UITableViewController {

    var categories: [MenuCategory] = []
        
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count of cat is \(categories.count)")
        return categories.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catcell", for: indexPath)

        // Configure the cell...
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = category.imageURL
        cell.imageView?.image = category.image
        
        
        return cell
    }
  

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
   

   
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let category = categories[indexPath.row].name
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //REMOVE CATEGORY FROM CLOUD DATA
            AppData.shared.removeReference(to: category)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let destinationVC = EditCategoryVC()
        destinationVC.category = self.categories[indexPath.row]
       // destinationVC.performSegue(withIdentifier: "EditCatSegue", sender: self)
        
    }

}
