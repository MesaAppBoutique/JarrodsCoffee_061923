//
//  ViewController.swift
//  JarrodsCoffee
//
//  Created by Thursin Atkinson on 4/28/21.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        DispatchQueue.main.async {
            
            //Download the images from the cloud
            AppData.shared.downloadImagesFromCloud()

            //Using a shared Singleton pattern to fetch items
            AppData.shared.fetchMenuItems { (menuItems) in
                //MenuCategory.shared.loadCategories()
                    print("items have been fetched!")
            }
            
            //bringing in an array of category objects
//            AppData.shared.fetchCategories { categories in
//                    print("categories have been fetched!")
//                AppData.shared.repairBrokenCategories()
//            }
            
        }
        
    }
    

    @IBAction func onClickPhone(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + "4808227146") else { return }
            UIApplication.shared.open(number)
    }
    //pass the name of the chosen category before showing the category menu
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "MenuCategorySegue" {
// 
//            if let menuCatVC = segue.destination as?
//                MenuCategoriesTableVC {
//                
//                AppData.shared.fetchCategoryData { categories in
//                    
//                    menuCatVC.categories = categories
//
//                }
//            }
//        }
//    }
    


}

