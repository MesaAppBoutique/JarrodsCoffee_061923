//
//  EditMenuItem.swift
//  JarrodsCoffee
//
//  Created by David Levy on 7/24/23.
//

// Photo picker tutorial
// https://www.youtube.com/watch?v=yggOGEzueFk

// Upload images to Firebase Storage
// https://www.youtube.com/watch?v=YgjYVbg1oiA

import UIKit

class EditMenuItemViewController: UIViewController {
    

    @IBOutlet weak var picker: UIPickerView!


    @IBOutlet weak var nameOutlet: UITextField!
    
    @IBOutlet weak var imageURLOutlet: UITextField!
    @IBOutlet weak var size1Outlet: UITextField!
    @IBOutlet weak var price1Outlet: UITextField!
    @IBOutlet weak var size2Outlet: UITextField!
    @IBOutlet weak var price2Outlet: UITextField!
    @IBOutlet weak var size3Outlet: UITextField!
    @IBOutlet weak var price3Outlet: UITextField!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBAction func saveItemAction(_ sender: Any) {
        MenuController.shared.addMenuItem(name: nameOutlet.text ?? "", size: [size1Outlet.text ?? "", size2Outlet.text ?? "", size3Outlet.text ?? ""], price: [price1Outlet.text ?? "", price2Outlet.text ?? "", price3Outlet.text ?? ""], category: MenuItem.allCategories[picker.selectedRow(inComponent: 0)] , image: imageOutlet.image)
        self.dismiss(animated: true)
    }
    
    @IBAction func editImageAction(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self as UIPickerViewDelegate
        picker.dataSource = self as UIPickerViewDataSource
        picker.center = self.view.center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// Required for the photo picker
extension EditMenuItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //get photo
        if let image = info[UIImagePickerController.InfoKey(rawValue:   "UIImagePickerControllerEditedImage")] as? UIImage {
            imageOutlet.image = image
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}


extension EditMenuItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
       }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return MenuItem.allCategories.count
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          let row = MenuItem.allCategories[row]
          return row
       }
    
}
