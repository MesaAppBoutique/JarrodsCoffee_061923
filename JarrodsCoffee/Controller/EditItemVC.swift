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

class EditItemVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var size1Outlet: UITextField!
    @IBOutlet weak var price1Outlet: UITextField!
    @IBOutlet weak var size2Outlet: UITextField!
    @IBOutlet weak var price2Outlet: UITextField!
    @IBOutlet weak var size3Outlet: UITextField!
    @IBOutlet weak var price3Outlet: UITextField!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBAction func saveItemAction(_ sender: Any) {
        
        AppData.shared.updateMenuItem(id: AppData.shared.showItems[AppData.shared.selectedItemIndex].id, name: nameOutlet.text ?? "", size: [size1Outlet.text ?? "", size2Outlet.text ?? "", size3Outlet.text ?? ""], price: [price1Outlet.text ?? "", price2Outlet.text ?? "", price3Outlet.text ?? ""], category: MenuItem.categories[picker.selectedRow(inComponent: 0)].id, image: imageOutlet.image)
        self.navigationController?.popViewController(animated: true)
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
        
        DispatchQueue.main.async {
            MenuCategory.shared.loadCategories()
        }

        //listenForChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateItem(item: AppData.shared.showItems[AppData.shared.selectedItemIndex])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func listenForChanges() {
        let collectionRef = AppData.shared.db.collection("menuItems")
        collectionRef.addSnapshotListener { [weak self] snapshot, error in
            
            guard let changes = snapshot?.documentChanges(includeMetadataChanges: false), error == nil else { return }
            
            guard let data = snapshot?.documentChanges.first?.document.data(with: .none) else { return }
            
            let item = AppData.shared.itemFrom(data: data)
  
            guard let item = item else { return }
            
            self?.updateItem(item: item)
            
            print("\(changes.count) changes happened in EditItemVC!")
        }
    }
    
    func updateItem (item:MenuItem) {
        DispatchQueue.main.async {
            self.nameOutlet.text = AppData.shared.showItems[AppData.shared.selectedItemIndex].name
            self.size1Outlet.text = AppData.shared.showItems[AppData.shared.selectedItemIndex].size[0]
            self.price1Outlet.text = AppData.shared.showItems[AppData.shared.selectedItemIndex].price[0]
            self.size2Outlet.text = AppData.shared.showItems[AppData.shared.selectedItemIndex].size[1]
            self.price2Outlet.text = AppData.shared.showItems[AppData.shared.selectedItemIndex].price[1]
            self.size3Outlet.text = AppData.shared.showItems[AppData.shared.selectedItemIndex].size[2]
            self.price3Outlet.text = AppData.shared.showItems[AppData.shared.selectedItemIndex].price[2]
            self.imageOutlet.image = AppData.shared.assignImage(withKey: AppData.shared.showItems[AppData.shared.selectedItemIndex].imageURL)
        }
    }
}


// Required for the photo picker
extension EditItemVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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


extension EditItemVC: UIPickerViewDelegate, UIPickerViewDataSource {
    

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
       }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return MenuItem.categories.count
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return MenuItem.categories[row].name
       }
    
}
