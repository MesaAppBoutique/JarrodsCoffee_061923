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
    
    
    
    //TODO: New Cloud Fetch
    func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {

        print("New Cloud Fetch for Menu Items")
        
        //FIXME:  THE DATA IS GETTING BLOCKED BY FIRESTORE PERMISSIONS SOMEWHERE "Missing or insufficient permissions."
        
        
        let db = Firestore.firestore() //init firestore
        
        db.collection("menuItems").getDocuments { snapshot, error in
            
            if error == nil {
                //no problems
                if let snapshot = snapshot {
                    //get all the data and make menu items
                    DispatchQueue.main.async {
                        //assign the menu items on the main thread
                        MenuItem.allItems = snapshot.documents.map { item in
                            return MenuItem(id: item.documentID,
                                            name: item["name"] as? String ?? "",
                                            size: item["size"] as? [String] ?? [""],
                                            price: item["price"] as? [Double] ?? [0],
                                            category: item["category"] as? String ?? "",
                                            imageURL: item["imageURL"] as? String ?? "")
                        }
                    }
                }
                
            } else {
                // handle the error
            }
            
        }
    }
    
    
        // fetch menuItems in selkected category
//        func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {
//
//            print("LOAD DATA FROM CLOUD")
//            print("IF NO MENU DATA ASK USER TO CHECK INTERNET CONNECTION")
//
//       //TODO: https://www.youtube.com/watch?v=xkxGoNfpLXs
//            //Documents = Document
//            //Collection [Document]
//            //menuItems = [MenuItem]
//            //FIXME: Replace the Fetch of Menu Items with Firebase data.
//
////
////            if LocalData.isLocal {
////                completion(LocalData.menuItems.filter { $0.category == categoryName || categoryName.isEmpty })
////                return
////            }
////
////            let initialMenuURL = baseURL.appendingPathComponent("menu")
////
////            var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
////
////            // add category only if categoryName is not empty
////            if categoryName != "" {
////                components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
////            }
////
////            let menuURL = components.url!
////
////            let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
////                // data from /menu converted into an array of MenuItem objects
////                let jsonDecoder = JSONDecoder()
////                if let data = data,
////                    let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
////                    completion(menuItems.items)
////                } else {
////                    completion(nil)
////                }
////            }
//            // begin the category menu call
////            task.resume()
//        }
//
        // fetch image data
        func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
            

            
            // construct URL components from URL
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
            
            // replace the host for the base URL's host
            components.host = baseURL.host
            
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

