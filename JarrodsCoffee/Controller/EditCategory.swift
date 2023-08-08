//
//  EditMenuItem.swift
//  JarrodsCoffee
//
//  Created by David Levy on 8/8/23.
//


import UIKit

class EditCategoryViewController: UIViewController {
    

    @IBOutlet weak var categoryOutlet: UITextField!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBAction func saveCategoryAction(_ sender: Any) {
        //MenuController.shared.addMenuItem(name: nameOutlet.text ?? "", size: [size1Outlet.text ?? "", size2Outlet.text ?? "", size3Outlet.text ?? ""], price: [price1Outlet.text ?? "", price2Outlet.text ?? "", price3Outlet.text ?? ""], category: categoryOutlet.text ?? "", image: imageOutlet.image)
        self.dismiss(animated: true)
    }
    
    @IBAction func editCategoryAction(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// Required for the photo picker
extension EditCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
