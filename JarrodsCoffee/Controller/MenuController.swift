//
//  MenuController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import UIKit
import Firebase

class MenuController {
    
        /// Used to share MenuController across all view controllers in the app
        static let shared = MenuController()
        
    
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
    
    
    func addMenuItem(name:String, size:[String], price:[String], category:String, imageURL:String) {
        let db = Firestore.firestore() //init firestore

        db.collection("menuItems").addDocument(data: ["category":category, "imageURL":imageURL, "name":name, "price":price, "size": size])

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

