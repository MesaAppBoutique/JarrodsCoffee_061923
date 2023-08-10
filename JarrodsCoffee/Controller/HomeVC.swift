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

            //Using a shared Singleton pattern to fetch items
            MenuData.shared.fetchMenuItems { (menuItems) in
                //MenuCategory.shared.loadCategories()
                    print("items have been fetched!")
            }
            
            //bringing in an array of category objects
            MenuData.shared.fetchCategories { categories in
                    print("categories have been fetched!")
            }
            
        }
        
    }
    

    @IBAction func onClickPhone(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + "4808227146") else { return }
            UIApplication.shared.open(number)
    }
    
}

