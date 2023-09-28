//
//  ViewController.swift
//  JarrodsCoffee
//
//  Created by Thursin Atkinson on 4/28/21.
//  Modified by David Levy on 8/20/23

import UIKit
import Firebase

class HomeVC: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            //Download the images from the cloud
            AppData.shared.downloadImagesFromCloud()
            
            //Using a shared Singleton pattern to fetch items
            AppData.shared.fetchMenuItems { (menuItems) in
                print("All items have been fetched!")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if AppData.shared.isAdminLoggedIn {
            self.adminButton.setTitle(AppData.shared.adminLogoutText, for: .normal)
        } else {
            self.adminButton.setTitle(AppData.shared.adminLoginText, for: .normal)
        }
        //Don't need the nav bar here... but do need it on the other screens
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    
    @IBAction func onClickPhone(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + "4808227146") else { return }
        UIApplication.shared.open(number)
    }
    
    @IBOutlet weak var adminButton: UIButton!
    
    ///This enables employee edit capabilities to add, edit and remove menu items.
    @IBAction func onClickAdmin(_ sender: UIButton) {
        //already logged in, let's log them out
        if AppData.shared.isAdminLoggedIn {
            AppData.shared.isAdminLoggedIn = true
            self.adminButton.setTitle(AppData.shared.adminLoginText, for: .normal)
            AppData.shared.isAdminLoggedIn = false
            
        //They aren't logged in. Let's see if they know the password before loggin them in.
        } else {
            generateLoginAlert()
        }
    }
    
    
    func generateLoginAlert () {
        //TODO: Eventually use official FireAuth here

        var textField = UITextField()
        let alert = UIAlertController(title: AppData.shared.adminLoginText, message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "enter password"
            textField = alertTextField //store textfield in local var
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { action in
            print(textField.text!)
            if self.passwordIsCorrect(guess: textField.text ?? "") {
                //they got the password right, let's enable admin mode and set the button text to log out
                AppData.shared.isAdminLoggedIn = true
                self.adminButton.setTitle(AppData.shared.adminLogoutText, for: .normal)
            } else {
                //Let's tell them they guessed incorrectly
                self.passwordNotCorrect()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            //Do nothing
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func passwordIsCorrect (guess: String) -> Bool {
        if guess == AppData.shared.adminPassword {
            return true
        } else {
            return false
        }
    }
    
    
    func passwordNotCorrect () {
        let alert = UIAlertController(title: "Oops! Wrong password.", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { action in
            
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

