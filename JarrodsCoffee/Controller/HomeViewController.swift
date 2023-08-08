//
//  ViewController.swift
//  JarrodsCoffee
//
//  Created by Thursin Atkinson on 4/28/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        DispatchQueue.main.async {

            //Using a shared Singleton pattern to fetch items
            MenuController.shared.fetchMenuItems { (menuItems) in
                MenuItem.loadCategories()
            }
        }
        
    }
    

    @IBAction func onClickPhone(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + "4808227146") else { return }
            UIApplication.shared.open(number)
    }
    
}

