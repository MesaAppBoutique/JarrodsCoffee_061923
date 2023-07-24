//
//  EditMenuItem.swift
//  JarrodsCoffee
//
//  Created by David Levy on 7/24/23.
//

import UIKit

class EditMenuItemViewController: UIViewController {
    

    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var categoryOutlet: UITextField!
    
    @IBOutlet weak var imageURLOutlet: UITextField!
    @IBOutlet weak var size1Outlet: UITextField!
    @IBOutlet weak var price1Outlet: UITextField!
    @IBOutlet weak var size2Outlet: UITextField!
    @IBOutlet weak var price2Outlet: UITextField!
    @IBOutlet weak var size3Outlet: UITextField!
    @IBOutlet weak var price3Outlet: UITextField!
    @IBAction func saveItemAction(_ sender: Any) {
        MenuController.shared.addMenuItem(name: nameOutlet.text ?? "", size: [size1Outlet.text ?? "", size2Outlet.text ?? "", size3Outlet.text ?? ""], price: [price1Outlet.text ?? "", price2Outlet.text ?? "", price3Outlet.text ?? ""], category: categoryOutlet.text ?? "", imageURL: imageURLOutlet.text ?? "")
        self.dismiss(animated: true)
    }
    
}
