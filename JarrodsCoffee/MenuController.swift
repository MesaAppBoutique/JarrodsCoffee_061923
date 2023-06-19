//
//  MenuController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import UIKit

class MenuController {
    
        /// Used to share MenuController across all view controllers in the app
        static let shared = MenuController()
        
        /// Base URL
        let baseURL = URL(string: "https://github.com/MesaAppBoutique/JarrodsCoffee/blob/main/JarrodsCoffee/data.json")!

        /// Execute GET request for categories
        func fetchCategories(completion: @escaping ([String]?) -> Void) {
            
            // if data is local use it
            if LocalData.isLocal {
                completion(LocalData.categories)
                return
            }
            
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
    
        // fetch menuItems in selkected category
        func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {
            if LocalData.isLocal {
                completion(LocalData.menuItems.filter { $0.category == categoryName || categoryName.isEmpty })
                return
            }
            
            let initialMenuURL = baseURL.appendingPathComponent("menu")
            
            var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
            
            // add category only if categoryName is not empty
            if categoryName != "" {
                components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
            }
            
            let menuURL = components.url!
            
            let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
                // data from /menu converted into an array of MenuItem objects
                let jsonDecoder = JSONDecoder()
                if let data = data,
                    let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                    completion(menuItems.items)
                } else {
                    completion(nil)
                }
            }
            // begin the category menu call
            task.resume()
        }
        
        // fetch image data
        func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
            
            // use local data
            if LocalData.isLocal {
                completion(UIImage(named: url.relativeString))
                return
            }
            
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

