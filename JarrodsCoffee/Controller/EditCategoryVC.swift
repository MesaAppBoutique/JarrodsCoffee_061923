//
//  EditMenuItem.swift
//  JarrodsCoffee
//
//  Created by David Levy on 8/8/23.
//


import UIKit

class EditCategoryVC: UIViewController {
    
    var category: MenuCategory?
    var catIndex: Int?

    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var imageOutlet: UIImageView?
    @IBAction func saveCategoryAction(_ sender: Any) {
                
        AppData.shared.updateCategory(id: AppData.shared.categories[AppData.shared.selectedCatIndex].id, name: textField?.text ?? "" , imageURL: category?.imageURL ?? "", image: imageOutlet?.image ?? AppData.defaultImage)

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editCategoryAction(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupTextField()
        category = AppData.shared.categories[AppData.shared.selectedCatIndex]
        print("Loaded category page and the category is \(String(describing: category?.name))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let cat = category {
            updateCategory(cat: cat)
        }
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func updateCategory (cat:MenuCategory) {
        DispatchQueue.main.async {
            self.textField?.text = AppData.shared.categories[AppData.shared.selectedCatIndex].name
            
            AppData.shared.loadImageFromStorage(imagePath: AppData.shared.categories[AppData.shared.selectedCatIndex].imageURL, imageView: self.imageOutlet!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// Required for the photo picker
extension EditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //get photo
        if let image = info[UIImagePickerController.InfoKey(rawValue:   "UIImagePickerControllerEditedImage")] as? UIImage {
            self.imageOutlet?.image = image
            picker.dismiss(animated: true)
            
            //delete old image
            DispatchQueue.main.async {
                
                AppData.shared.deleteImage(imageURL: AppData.shared.categories[AppData.shared.selectedCatIndex].imageURL) { err in
                    if let error = err {
                        print("Error deleting IMAGE")
                        
                        //assign new image to view
                        
                    } else {
                        print("Success deleting IMAGE")
                        
                        //assign new image to view
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
