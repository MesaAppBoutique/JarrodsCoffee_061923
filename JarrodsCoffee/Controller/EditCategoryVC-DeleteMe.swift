//
//  EditMenuItem.swift
//  JarrodsCoffee
//
//  Created by David Levy on 8/8/23.
//


import UIKit

class EditCategoryVC: UIViewController {
    
    var category = MenuCategory()

    @IBOutlet weak var categoryOutlet: UITextField!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBAction func saveCategoryAction(_ sender: Any) {
        
        AppData.shared.addCategory(name: categoryOutlet.text ?? "", imageURL: category.imageURL, image: category.image)

        self.dismiss(animated: true)
    }
    
    @IBAction func editCategoryAction(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.categoryOutlet.text = self.category.name
            self.imageOutlet.image = self.category.image
        }
            //Enable nav bar
        self.navigationController?.isNavigationBarHidden = false
//            self.imageOutlet.image = Data.shared.assignImage(withKey: self.categoryName)
//        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


// Required for the photo picker
extension EditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
