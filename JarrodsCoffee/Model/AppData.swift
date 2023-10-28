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
import SwiftUI

class AppData {
    
    /// Used to share MenuController across all view controllers in the app
    static let shared = AppData()
    let db = Firestore.firestore() //init firestore

    private var downloadedImages = [MenuImage]()
    var downloadedMenu = [MenuItem]()
    var menuItems: [MenuItem] = []
    var shownItems: [MenuItem] = []
    var categories: [MenuCategory] = []

    var selectedItemIndex = 0
    var selectedCatIndex = 0

    static var defaultImage = UIImage(named: "Image")!
    static var defaultItem = MenuItem(id: UUID().uuidString, categoryId: "Unassigned", imageURL: "", name: "", price: ["","",""], size: ["","",""])
    /// Base URL
    let baseURL = URL(string: "https://github.com/MesaAppBoutique/JarrodsCoffee/blob/main/JarrodsCoffee/data.json")!
    var isAdminLoggedIn = false
    let adminPassword = "7146"
    let adminLoginText = "Employee Access"
    let adminLogoutText = "Log out"
    
    
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
    
    func updateCategory(id: String, name: String, imageURL: String, image: UIImage) {
        
        AppData.shared.categories[AppData.shared.selectedCatIndex] = categories[AppData.shared.selectedCatIndex] //I don't get this part... is this even doing anything?
        
        AppData.shared.categories[AppData.shared.selectedCatIndex].id = id
        AppData.shared.categories[AppData.shared.selectedCatIndex].name = name
        AppData.shared.categories[AppData.shared.selectedCatIndex].imageURL = imageURL
        AppData.shared.categories[AppData.shared.selectedCatIndex].image = image
        
        
        let docRef = db.collection("categories").document(id)
                
        docRef.updateData(["name": name, "imageURL": imageURL]) { error in
            if let error = error  {
                print("\(error) \n error updating, let's try and make a new document")
                
                self.db.collection("categories").addDocument(data: ["name": name, "imageURL": AppData.defaultItem.imageURL])
                
            } else {
                print("successfully updated!")
                let imageURL = self.uploadImage(image)
                AppData.shared.categories[AppData.shared.selectedCatIndex].imageURL = imageURL
                docRef.updateData(["imageURL": imageURL])
            }
        }
        

    }
                
    
    func updateMenuItem(id: String, name: String, size: [String], price: [String], category: String, image: UIImage?, imageURL: String) {
                
        AppData.shared.shownItems[AppData.shared.selectedItemIndex] = shownItems[AppData.shared.selectedItemIndex] //I don't get this part... is this even doing anything?
        
        AppData.shared.shownItems[AppData.shared.selectedItemIndex].id = id
        AppData.shared.shownItems[AppData.shared.selectedItemIndex].name = name
        AppData.shared.shownItems[AppData.shared.selectedItemIndex].size = size
        AppData.shared.shownItems[AppData.shared.selectedItemIndex].price = price
        AppData.shared.shownItems[AppData.shared.selectedItemIndex].imageURL = imageURL
        
        
        let docRef = db.collection("menuItems").document(id)
                
        docRef.updateData(["name": name, "category": category, "size": size, "price": price]) { error in
            if let error = error  {
                print("\(error) \n error updating, let's try and make a new document")
                
                // This seems a little jank.  Might work on moving it to check if exists prior to performing update.  Then if exists, update, if not addDoc.
                //There was a problem, we should create a new item here?
                self.db.collection("menuItems").addDocument(data: ["category": category, "imageURL": AppData.defaultItem.imageURL, "name": name, "price":price, "size": size])

                
            } else {
                print("successfully updated!")
                let imageURL = self.uploadImage(image)
                AppData.shared.shownItems[AppData.shared.selectedItemIndex].imageURL = imageURL
                docRef.updateData(["imageURL": imageURL])
            }
        }
        
        

        
        
        
        
        
        //CREATES NEW ITEM BUT WON'T UPDATE
//        db.collection("menuItems")
//            .whereField("uid", isEqualTo: id) //FIXME: NOT WORKING YET!
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    // Some error occured
//                } else if querySnapshot!.documents.count == 0 {
//                    print("didn't find it, let's make a new item")
//                    self.db.collection("menuItems").addDocument(data: ["category": category, "imageURL": imageURL, "name":name, "price":price, "size": size])
//                } else {
//                    print("lets update the first record with the same id")
//                    let document = querySnapshot!.documents.first
//                    document?.reference.updateData(["category":category, "imageURL": imageURL, "name":name, "price":price, "size": size])
//                }
//            }
        
        // Upload that data
        
        
        //Do we need this HERE?
        //FIXME:
        //AppData.shared.downloadImagesFromCloud()

    }
    
    
    
    func delete(item: MenuItem, index: Int, completion: @escaping (Error?) -> Void) {
        
        shownItems.remove(at: index)
        
        // Reference to the document you want to delete
        let documentReference = db.collection("menuItems").document(item.id)
         
         // Delete the document
         documentReference.delete { error in
             if let error = error {
                 print("Error deleting document: \(error)")
                 completion(error)
             } else {
                 print("Document successfully deleted.")
                 completion(nil)
             }
         }
    }

    func delete(cat: MenuCategory, index: Int, completion: @escaping (Error?) -> Void) {
        
        categories.remove(at: index)
        
        // Reference to the document you want to delete
        let documentReference = db.collection("categories").document(cat.id)
         
         // Delete the document
         documentReference.delete { error in
             if let error = error {
                 print("Error deleting document: \(error)")
                 completion(error)
             } else {
                 print("Document successfully deleted.")
                 completion(nil)
             }
         }
    }
    
    /// Delete the associated image from the Firebase Storage
    func deleteImage(imageURL: String, completion: @escaping (Error?) -> Void) {
        
        let storageRef = Storage.storage().reference()
        
        let fileRef = storageRef.child(imageURL)
        
        fileRef.delete { error in
            if error == nil {
                print("image file deleted")
                DispatchQueue.main.async {
                    self.downloadedImages.removeAll { img in
                        img.url == imageURL
                    }

                }
            }
        }
    }
    
    
    func addCategory(name: String, imageURL: String, image: UIImage?) {
                
        db.collection("categories")
            .whereField("name", isEqualTo: name)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    // Some error occured
                } else if querySnapshot!.documents.count == 0 {
                    //none exist with that name, let's make a new one!
                    let newURL = self.uploadImage(image)
                    self.db.collection("categories").addDocument(data: ["imageURL": newURL, "name": name])

                } else {
                    // lets update the first record with the same name
                    let document = querySnapshot!.documents.first
                    let newURL = self.uploadImage(image)
                    document?.reference.updateData(["imageURL": newURL, "name": name])
                }
            }
        
        // Upload that data
        
        
//FIXME:
       //AppData.shared.downloadImagesFromCloud()

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
        guard imageData != nil else  { return "no image" }
        // create a reference to the file path
        let fileRef = storageRef.child(path)
        // upload the data
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                //add to cached images
                DispatchQueue.main.async {
                    if let image = image {
                        print("Before saving to downloadedImages after upload the image is \(image)")
                        let menuImage = MenuImage(url: path, image: image)
                        self.downloadedImages.append(MenuImage(url: path, image: image))
                    }
                }
            }
        }
        return path
    }
    
    

    
    //This function downloads all images, not just the ones needed.  I think there's probably a better way to handle this call, on demand.  
//    func downloadImagesFromCloud() {
//
//        //clear images
//        //downloadedImages = []
//
////        db.collection("images").getDocuments { snapshot, error in
////            if error == nil && snapshot != nil {
//                var paths = [String]()
//        for eachItem in menuItems {
//            paths.append(eachItem.imageURL)
//        //for doc in snapshot!.documents {
//                    //paths.append(doc["url"] as? String ?? "Image")
//                }
//                for path in paths {
//                    let storageRef = Storage.storage().reference()
//                    let fileRef = storageRef.child(path)
//                    fileRef.getData(maxSize: 5 * 2000 * 2000) { data, error in
//                        if error == nil && data != nil {
//                            if let imageFromData = UIImage(data: data!) {
//                                DispatchQueue.main.async {
//                                    //print("Before saving to downloadedImages after download the snapshot doc is \(imageFromData)")
//                                    let menuImage = MenuImage(url: path, image: imageFromData)
//                                    self.downloadImage.append(menuImage)
//                                    print("image count is \(self.downloadedImages.count)")
//                                }
//                            }
//                        }
//                    }
//               // }
//           // }
//        }
//    }
    
//    func downloadImage (for imageURL: String) -> UIImage {
//
//        var image = UIImage(named: "Iced_Tea")
//
//        let storageRef = Storage.storage().reference()
//
//        let fileRef = storageRef.child("\(imageURL)")
//        print("image url is -> \(imageURL)")
//        print("file ref is \(fileRef)")
//
//            fileRef.getData(maxSize: 5 * 2000 * 2000) { data, error in
//
//                if error == nil && data != nil {
//
//                    if let imageFromData = UIImage(data: data!) {
//
//                        image = imageFromData
//
//                    }
//
//                }
//
//
//        }
//        return image!
//    }
    
    

    func loadImageFromStorage(imagePath: String, imageView: UIImageView, placeholderImage: UIImage? = nil) {
        let storage = Storage.storage()
        let storageReference = storage.reference(withPath: imagePath)
        var isLoaded = false
        
        // Set a placeholder image while the download is in progress
        if let placeholderImage = placeholderImage {
            imageView.image = placeholderImage
        }
        
        //Use an array of stored images and check here if the image already is downloaded.  Then if it is already downloaded return the matching image.  If it isn't then continue with the download.  This way we aren't using a TON of data every time the user loads each view.

        for menuImg in downloadedImages {
            if menuImg.url == imagePath {
                imageView.image = menuImg.image
                isLoaded = true
            }
        }

        // Check if we loaded a cached version of the image
        guard !isLoaded else { return }
 
        // Download the image if we haven't found it
        storageReference.getData(maxSize: 5 * 2000 * 2000) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                // Handle the error here (e.g., show an error message)
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    // Update the UIImageView with the downloaded image
                    self.cacheImageLocally(url: imagePath, image: image)

                    imageView.image = image
                } else {
                    print("Failed to create UIImage from data")
                    // Handle the error here (e.g., show an error message)
                }
            }
        }
    }

    func cacheImageLocally(url: String, image: UIImage) {
        downloadedImages.append(MenuImage(url: url, image: image))
    }
    
    /// Associate the image that is downloaded based on the url path that is stored for each menuImage
//    func assignImage(imageURL: String) -> UIImage {
//        // Of the menuImages we have downloaded from Firestore data, return if any match the url for this menu item.
//        //if let menuImage = AppData.shared.downloadedImages.first (where: { $0.url == withKey } ) {
//       //     return menuImage.image
////        if let menuImage = AppData.shared.downloadImage(for: imageURL) {
////
////        } else {
////            //If none match then just return the default image.
////            return AppData.defaultImage
////        }
//
//        var image = UIImage(named: "Image")
//
////        DispatchQueue.main.async {
////            image = self.downloadImage(for: imageURL)
////        }
//
//        return image!
//
//    }
    
    
    func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {
        
        print("Loading menu items from Firestore cloud data.")
        
        
        db.collection("menuItems").addSnapshotListener { [self] snapshot, error in
            if error == nil {
                
                if let snapshot = snapshot {
                    AppData.shared.menuItems = snapshot.documents.map { item in
                        
                        print("First item ID is \(item.documentID )")
                        print("Category ID is \(String(describing: item["category"]) )")

                        let imageURL = item["imageURL"] as? String ?? ""

                                                
                        return MenuItem(id: item.documentID,
                                        categoryId: item["category"] as? String ?? "",
                                        imageURL: item["imageURL"] as? String ?? "",
                                        name: item["name"] as? String ?? "",
                                        price: item["price"] as? [String] ?? ["unknown"],
                                        size: item["size"] as? [String] ?? [""])
                    }
                }
                completion(AppData.shared.menuItems)
            } else {
                print("error fetching!")
            }
        }
    }
    
    
    func fetchCategories(categoryId: String = "", completion: @escaping([MenuCategory]?) -> Void) {
        
        print("Loading categories from Firestore cloud data.")
                
        db.collection("categories").addSnapshotListener { [self] snapshot, error in
            if error == nil {
                
                if let snapshot = snapshot {
                    AppData.shared.categories = snapshot.documents.map { item in
                        
                        print("First item is \(item["imageURL"] ?? "")")
                        let imageURL =  item["imageURL"] as? String ?? ""

                                                
                        return MenuCategory(id: item.documentID,
                                            name: item["name"] as? String ?? "",
                                            imageURL: imageURL,
                                            image: AppData.defaultImage)
                    }
                }
                completion(AppData.shared.categories)
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
        for (index, item) in AppData.shared.menuItems.enumerated() {
            if item.categoryId.uppercased() == categoryId.uppercased() { //I am not sure why the stored property's character case does not at all match.  So let's just compare upper cased versions.
                AppData.shared.menuItems[index].categoryId = "Undefined Category"
            }
        }
        persist()
    }
    
    func persist() {
        print("PERSIST ADD CODE")
    }
    
    
    func fetchMenuData(completion: @escaping ([MenuItem]) -> Void) {
        
        db.collection("menuItems").getDocuments { [self] (snapshot, error) in
            // Handle error
            
            var menuItems: [MenuItem] = []
            
            if error == nil {
                
                if let snapshot = snapshot {
                    AppData.shared.menuItems = snapshot.documents.map { item in
                        
                        print("First item ID is \(item.documentID )")
                        print("Category ID is \(String(describing: item["category"]) )")
                        
                        let imageURL = item["imageURL"] as? String ?? ""
                        
                        return MenuItem(id: item.documentID,
                                        categoryId: item["category"] as? String ?? "",
                                        imageURL: item["imageURL"] as? String ?? "",
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
        
        db.collection("categories").getDocuments { [self] (snapshot, error) in
            // Handle error
            
            var categories: [MenuCategory] = []
            
            if error == nil {
                
                if let snapshot = snapshot {
                    categories = snapshot.documents.map { item in
                        
                        print("First item ID is \(item.documentID )")
                        
                        let imageURL = item["imageURL"] as? String ?? ""
                        
                        return MenuCategory(id: item.documentID,
                                            name: item["name"] as? String ?? "",
                                            imageURL: imageURL,
                                            image: AppData.defaultImage)
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

    
    func itemFrom(data: [String:Any]) -> MenuItem? {
        
        guard let id = data["id"] as? String else {
            return nil
        }

        let imageURL = data["imageURL"] as? String ?? ""        
        
        let item = MenuItem(id: id,
                        categoryId: data["category"] as? String ?? "",
                        imageURL: data["imageURL"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        price: data["price"] as? [String] ?? ["unknown"],
                        size: data["size"] as? [String] ?? [""])
        
        return item
    }
    
}

