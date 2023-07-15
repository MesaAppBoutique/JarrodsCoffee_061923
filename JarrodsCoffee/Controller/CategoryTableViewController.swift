//
//  CategoryTableViewController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    /// Names of the menu categories
    var categories = [String]()
    
    /// Array of menu items to be fetched from data
    var menuItems = [MenuItem]()
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the menu for all categories
        MenuController.shared.fetchMenuItems() { (menuItems) in
            if let menuItems = menuItems {
                for item in menuItems {
                    let category = item.category
                    // add category only if it was not added before
                    if !self.categories.contains(category) {
                        self.categories.append(category)
                    }
                }
                // remember the list of items
                self.menuItems = menuItems
                
                // update the table with categories
                self.updateUI(with: self.categories)
            }
        }
    }
    
    // Update categories
    func updateUI(with categories: [String]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)

        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // Configure category cells
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let categoryString = categories[indexPath.row]
        
        cell.textLabel?.text = categoryString.capitalized
        
        guard let menuItem = menuItems.first(where: { item in
            return item.category == categoryString
        }) else { return }
        
        // fetch the image from assets
        //FIXME: Replace default image
        MenuController.shared.fetchImage(url: URL(string:menuItem.imageURL) ?? URL(string:"https://static.wixstatic.com/media/3fde0f_21019cad931b465c880811f19594557a~mv2.png/v1/fill/w_804,h_998,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/white.png")!) { image in
            guard let image = image else { return }
            
            DispatchQueue.main.async {
                guard let currentIndexPath = self.tableView.indexPath(for: cell) else { return }
                
                // check if the cell was not yet recycled
                guard currentIndexPath == indexPath else { return }
                
                // set the thumbnail image
                cell.imageView?.image = image
                
                // fit the image to the cell
                self.fitImage(in: cell)
            }
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

    //pass the name of the chosen category before showing the category menu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // make sure the segue is from category to menu table view controllers
        if segue.identifier == "MenuSegue" {
            let menuTableViewController = segue.destination as! MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            
            menuTableViewController.category = categories[index]
        }
    }
}

