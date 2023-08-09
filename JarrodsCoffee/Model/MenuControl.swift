//
//  MenuController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class MenuControl {
    
    /// Used to share MenuController across all view controllers in the app
    static let shared = MenuControl()
    var downloadedImages = [MenuImage]()
    var downloadedMenu = [MenuItem]()
    var selectedImage = UIImage(named: "Image")!
    /// Base URL
    let baseURL = URL(string: "https://github.com/MesaAppBoutique/JarrodsCoffee/blob/main/JarrodsCoffee/data.json")!
    
    
    /// Execute GET request for categories
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        
        
        let categoryURL = baseURL.appendingPathComponent("categories")
        
        // create a task for network call to get the list of categories
        let task = URLSession.shared.dataTask(with: categoryURL) { data, response, error in
            // /categories endpoint decoded into a Categories object
            if let data = data,
               let jsonDictionary = ((try? JSONSerialization.jsonObject(with: data) as? [String:Any]) as [String : Any]??),
               let categories = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }
        // begin the call to get the list of categories
        task.resume()
    }
    
    
    func addMenuItem(name: String, size: [String], price: [String], category: String, image: UIImage?) {
        
        
        let db = Firestore.firestore() //init firestore
        let imageURL = uploadImage(image)
        
        
        // Upload that data
        
        //Save reference to file in Firestore DB
        
        db.collection("menuItems").addDocument(data: ["category":category, "imageURL": imageURL, "name":name, "price":price, "size": size])
        
        MenuControl.shared.downloadImagesFromCloud()

    }
    
    func uploadImage(_ image: UIImage?) -> String {
        // a string to reference the new image path
        let path = "images/\(UUID().uuidString).jpg"
        // check we have an image or bail
        guard image != nil else  { return "no image" }
        // create a reference to the storage container path
        let storageRef = Storage.storage().reference()
        // compress the image into data
        let imageData = image!.jpegData(compressionQuality: 0.8)
        // check that we have data
        guard imageData != nil else  { return "no image" } //TODO: Make Error String
        // create a reference to the file path
        let fileRef = storageRef.child(path)
        // upload the data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                let db = Firestore.firestore()
                // if the data uploaded, then also store the file path
                db.collection("images").document().setData(["url":path])
                DispatchQueue.main.async {
                    if let image = image {
                        print("Before saving to downloadedImages after upload the image is \(image)")
                        let menuImage = MenuImage(key: path, image: image)
                        self.downloadedImages.append(menuImage)
                    }
                }
            }
        }
        return path
    }
    
    func downloadImagesFromCloud() {
        let db = Firestore.firestore()
        
        //clear images
        downloadedImages = []
        
        db.collection("images").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var paths = [String]()
                for doc in snapshot!.documents {
                    paths.append(doc["url"] as! String)
                }
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    fileRef.getData(maxSize: 5 * 2000 * 2000) { data, error in
                        if error == nil && data != nil {
                            if let imageFromData = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    print("Before saving to downloadedImages after download the snapshot doc is \(imageFromData)")
                                    let menuImage = MenuImage(key: path, image: imageFromData)
                                    self.downloadedImages.append(menuImage)
                                    print("image count is \(self.downloadedImages.count)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Associate the image that is downloaded based on the url path that is stored for each menuImage
    func assignImage(path: String) -> UIImage {
        // Of the menuImages we have downloaded from Firestore data, return if any match the url for this menu item.
        if let menuImage = MenuControl.shared.downloadedImages.first (where: { $0.key == path } ) {
            return menuImage.image
            
        } else {
            //If none match then just return the default image.
            return UIImage(named: "Image")!
        }
    }
    
    
    func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {
        
        print("Loading menu items from Firestore cloud data.")
        
        let db = Firestore.firestore() //init firestore
        
        db.collection("menuItems").addSnapshotListener { [self] snapshot, error in
            if error == nil {
                
                if let snapshot = snapshot {
                    MenuItem.allItems = snapshot.documents.map { item in
                        
                        print("First item is \(item["imageURL"] ?? "")")
                        
                        let imageURL = item["imageURL"] as? String ?? ""
                        var tempImage = assignImage(path: imageURL)

                        DispatchQueue.main.async {
                            tempImage = self.assignImage(path: imageURL)
                        }
                                                
                        return MenuItem(id: item.documentID,
                                        category: item["category"] as? String ?? "",
                                        imageURL: item["imageURL"] as? String ?? "",
                                        image: tempImage,
                                        name: item["name"] as? String ?? "",
                                        price: item["price"] as? [String] ?? ["unknown"],
                                        size: item["size"] as? [String] ?? [""])
                    }
                }
                completion(MenuItem.allItems)
            } else {
                print("error fetching!")
            }
        }
    }
    
    func menuFiltered(by category: String, fromItems menuItems: [MenuItem]) -> [MenuItem] {
        return menuItems.filter({ $0.category == category })
    }
    
    func removeReference(to category:String) {
        for (index, item) in MenuItem.allItems.enumerated() {
            if item.category == category {
                MenuItem.allItems[index].category = "Undefined Category"
            }
        }
        persist()
    }
    
    func persist() {
        print("PERSIST ADD CODE")
    }
}

