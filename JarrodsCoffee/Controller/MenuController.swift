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

class MenuController {
    
    /// Used to share MenuController across all view controllers in the app
    static let shared = MenuController()
    var downloadedImages = [UIImage]()
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
        
        MenuController.shared.downloadImages()

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
                        self.downloadedImages.append(image)
                    }
                }
            }
        }
        return path
    }
    
    func downloadImages() {
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
                                    self.downloadedImages.append(imageFromData)
                                    print(self.downloadedImages)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func downloadImage(path: String) -> UIImage {
        
        print("download at \(path) <-")
        
        let imageSeeking = UIImage(named: path)
        
        let db = Firestore.firestore()
        
        
        var newImage = MenuController.shared.downloadedImages.first { image in
            image == imageSeeking
        }
                
//        let storageRef = Storage.storage().reference()
//
//        let fileRef = storageRef.child(path)
//
//        print("file ref is \(fileRef)")
//        fileRef.getData(maxSize: 5 * 2000 * 2000) { data, error in
//
//            if error == nil && data != nil {
//                if let imageFromData = UIImage(data: data!) {
//                    print("imaging from data!")
//                        newImage = imageFromData
//                    }
//            } else {
//                print("error creating image \(String(describing: error))")
//            }
//            }
        return newImage ?? UIImage(named: "Image")!
    }
    
    
    func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {
        
        print("Loading menu items from Firestore cloud data.")
        
        let db = Firestore.firestore() //init firestore
        
        //TEST This will add a new document
        //db.collection("menuItems").addDocument(data: ["year" : 2023, "type":"Merlot", "label":"Apothic"])
        
        db.collection("menuItems").addSnapshotListener { snapshot, error in
            if error == nil {
                
                if let snapshot = snapshot {
                    MenuItem.allItems = snapshot.documents.map { item in
                        
                        print("First item is \(item["imageURL"] ?? "")")
                        
                        return MenuItem(id: item.documentID,
                                        category: item["category"] as? String ?? "",
                                        imageURL: item["imageURL"] as? String ?? "",
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
    
    // fetch image data
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        
        
        // construct URL components from URL
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        // replace the host for the base URL's host
        // components.host = baseURL.host
        
        // construct the new url with the replaced host
        guard let url = components.url else { return }
        
        // create a task for image fetch URL call
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            // check the data is returned and image is valid
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        // begin the image fetch network call
        task.resume()
    }
}

