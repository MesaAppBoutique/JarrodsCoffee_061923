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

class AppData {
    
    /// Used to share MenuController across all view controllers in the app
    static let shared = AppData()
    var downloadedImages = [MenuImage]()
    var downloadedMenu = [MenuItem]()
    var selectedImage = UIImage(named: "Image")!
    /// Base URL
    let baseURL = URL(string: "https://github.com/MesaAppBoutique/JarrodsCoffee/blob/main/JarrodsCoffee/data.json")!
    
    
//    /// Execute GET request for categories
//    func fetchCategories(completion: @escaping ([String]?) -> Void) {
//
//
//        let categoryURL = baseURL.appendingPathComponent("categories")
//
//        // create a task for network call to get the list of categories
//        let task = URLSession.shared.dataTask(with: categoryURL) { data, response, error in
//            // /categories endpoint decoded into a Categories object
//            if let data = data,
//               let jsonDictionary = ((try? JSONSerialization.jsonObject(with: data) as? [String:Any]) as [String : Any]??),
//               let categories = jsonDictionary?["categories"] as? [String] {
//                completion(categories)
//            } else {
//                completion(nil)
//            }
//        }
//        // begin the call to get the list of categories
//        task.resume()
//    }
    
    
    func addMenuItem(name: String, size: [String], price: [String], category: String, image: UIImage?) {
        
        let db = Firestore.firestore() //init firestore
        let imageURL = uploadImage(image)
        
        db.collection("menuItems")
            .whereField("name", isEqualTo: name)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    // Some error occured
                } else if querySnapshot!.documents.count == 0 {
                    //none exist with that name, let's make a new one!
                    db.collection("menuItems").addDocument(data: ["category": category, "imageURL": imageURL, "name":name, "price":price, "size": size])
                } else {
                    // lets update the first record with the same name
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData(["category":category, "imageURL": imageURL, "name":name, "price":price, "size": size])
                }
            }
        
        // Upload that data
        
        
        //Do we need this HERE?
        AppData.shared.downloadImagesFromCloud()

    }
    
    
    func addCategory(name: String, imageURL: String, image: UIImage?) {
        
        let db = Firestore.firestore() //init firestore
        
        db.collection("categories")
            .whereField("name", isEqualTo: name)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    // Some error occured
                } else if querySnapshot!.documents.count == 0 {
                    //none exist with that name, let's make a new one!
                    let newURL = self.uploadImage(image)
                    db.collection("categories").addDocument(data: ["imageURL": newURL, "name": name])

                } else {
                    // lets update the first record with the same name
                    let document = querySnapshot!.documents.first
                    let newURL = self.uploadImage(image)

                    document?.reference.updateData(["imageURL": newURL, "name": name])
                }
            }
        
        // Upload that data
        
        
        //Do we need this HERE?
        AppData.shared.downloadImagesFromCloud()

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
    func assignImage(withKey: String) -> UIImage {
        // Of the menuImages we have downloaded from Firestore data, return if any match the url for this menu item.
        if let menuImage = AppData.shared.downloadedImages.first (where: { $0.key == withKey } ) {
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
                    MenuItem.shared.allItems = snapshot.documents.map { item in
                        
                        print("First item ID is \(item.documentID )")
                        print("Category ID is \(String(describing: item["category"]) )")

                        let imageURL = item["imageURL"] as? String ?? ""
                        var tempImage = assignImage(withKey: imageURL)

                                                
                        return MenuItem(id: item.documentID,
                                        categoryId: item["category"] as? String ?? "",
                                        imageURL: item["imageURL"] as? String ?? "",
                                        image: tempImage,
                                        name: item["name"] as? String ?? "",
                                        price: item["price"] as? [String] ?? ["unknown"],
                                        size: item["size"] as? [String] ?? [""])
                    }
                }
                completion(MenuItem.shared.allItems)
            } else {
                print("error fetching!")
            }
        }
    }
    
    
    func fetchCategories(categoryId: String = "", completion: @escaping([MenuCategory]?) -> Void) {
        
        print("Loading categories from Firestore cloud data.")
        
        let db = Firestore.firestore() //init firestore
        
        db.collection("categories").addSnapshotListener { [self] snapshot, error in
            if error == nil {
                
                if let snapshot = snapshot {
                    MenuItem.shared.categories = snapshot.documents.map { item in
                        
                        print("First item is \(item["imageURL"] ?? "")")
                        let imageURL =  item["imageURL"] as? String ?? ""
                        let tempImage = assignImage(withKey: imageURL)

                                                
                        return MenuCategory(id: item.documentID,
                                            name: item["name"] as? String ?? "",
                                            imageURL: imageURL,
                                            image: tempImage)
                    }
                }
                completion(MenuItem.shared.categories)
            } else {
                print("error fetching!")
            }
        }
    }
    
    func repairBrokenCategories () {
        print("TODO: If an item has a category that can not be loaded in the categories database, then set that item's category as unassigned and create an unassigned category to the shared.categories array so it can be selected still")
        //FIXME:  Add in some extra logic to find any categories that are named in the Item, but that don't exist in the Category database.
        //If an item has a category that can not be loaded in the categories database, then set that item's category as "unassigned" and create an "unassigned" category to the shared.categories array so it can be selected still.
        
        
    }
    
    func menuFiltered(by categoryId: String, fromItems menuItems: [MenuItem]) -> [MenuItem] {
        let foundItems = menuItems.filter({
            $0.categoryId.uppercased() == categoryId.uppercased()
            
        })
        
//        let notFoundItems = menuItems.filter({
//            $0.categoryId.uppercased() != categoryId.uppercased()
//        })
//
//        var unassignedItems = notFoundItems.map{ (item) -> MenuItem in
//            var _item = item
//            _item.categoryId = "unassigned category"
//            return _item
//        }
        
        return foundItems //+ unassignedItems
    }
    
    func removeReference(to categoryId:String) {
        for (index, item) in MenuItem.shared.allItems.enumerated() {
            if item.categoryId.uppercased() == categoryId.uppercased() { //I am not sure why the stored property's character case does not at all match.  So let's just compare upper cased versions.
                MenuItem.shared.allItems[index].categoryId = "Undefined Category"
            }
        }
        persist()
    }
    
    func persist() {
        print("PERSIST ADD CODE")
    }
    
    
    func fetchMenuData(completion: @escaping ([MenuItem]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("menuItems").getDocuments { [self] (snapshot, error) in
            // Handle error
            
            var menuItems: [MenuItem] = []
            
            if error == nil {
                
                if let snapshot = snapshot {
                    MenuItem.shared.allItems = snapshot.documents.map { item in
                        
                        print("First item ID is \(item.documentID )")
                        print("Category ID is \(String(describing: item["category"]) )")
                        
                        let imageURL = item["imageURL"] as? String ?? ""
                        var tempImage = assignImage(withKey: imageURL)
                        
                        
                        return MenuItem(id: item.documentID,
                                        categoryId: item["category"] as? String ?? "",
                                        imageURL: item["imageURL"] as? String ?? "",
                                        image: tempImage,
                                        name: item["name"] as? String ?? "",
                                        price: item["price"] as? [String] ?? ["unknown"],
                                        size: item["size"] as? [String] ?? [""])
                    }
                }
                //                completion(MenuItem.shared.allItems)
                
                completion(menuItems)
            }
        }
        
        
        // Asynchronously fetch and display image data
        //    func fetchAndDisplayImages(for menuItems: [MenuItem]) {
        //        for menuItem in menuItems {
        //            if let imageUrl = menuItem.imageUrl {
        //                // Use URLSession or a library like SDWebImage to download the image
        //                // Update UIImageView with the downloaded image
        //            }
        //        }
        //    }
    }

    
    
    func fetchCategoryData(completion: @escaping ([MenuCategory]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("categories").getDocuments { [self] (snapshot, error) in
            // Handle error
            
            var categories: [MenuCategory] = []
            
            if error == nil {
                
                if let snapshot = snapshot {
                    categories = snapshot.documents.map { item in
                        
                        print("First item ID is \(item.documentID )")
                        
                        let imageURL = item["imageURL"] as? String ?? ""
                        let tempImage = assignImage(withKey: imageURL)
                        
                        return MenuCategory(id: item.documentID,
                                            name: item["name"] as? String ?? "",
                                            imageURL: imageURL,
                                            image: tempImage)
                    }
                }
                //                completion(MenuItem.shared.allItems)
                print("Categories found number \(categories.count)")
                completion(categories)
            }
        }
        
        
        // Asynchronously fetch and display image data
        //    func fetchAndDisplayImages(for menuItems: [MenuItem]) {
        //        for menuItem in menuItems {
        //            if let imageUrl = menuItem.imageUrl {
        //                // Use URLSession or a library like SDWebImage to download the image
        //                // Update UIImageView with the downloaded image
        //            }
        //        }
        //    }
    }

}

