//
//  ViewController.swift
//  JarrodsCoffee
//
//  Created by Thursin Atkinson on 4/28/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        DispatchQueue.main.async {

            self.fetchMenuItems { (menuItems) in
            
            print("Maybe we found menu items? -> #\(menuItems?.count)")
            
            if let menuItems = menuItems {
                for item in menuItems {
                    print("Found Item!  \(item)")
                    //                    let category = item.category
                    //                    // add category only if it was not added before
                    //                    if !self.categories.contains(category) {
                    //                        self.categories.append(category)
                    //                    }
                    //}
                    // remember the list of items
                    //                self.menuItems = menuItems
                    
                    // update the table with categories
                    //                self.updateUI(with: self.categories)
                }
            }
        }
        }
        
    }
    
    func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {

        print("New Cloud Fetch for Menu Items")
        
        //FIXME:  THE DATA IS GETTING BLOCKED BY FIRESTORE PERMISSIONS SOMEWHERE "Missing or insufficient permissions."
        
        
        let db = Firestore.firestore() //init firestore
        
        
//        let listener = db.collection("parties").addSnapshotListener { (snapshot, error) in
//            switch (snapshot, error) {
//            case (.none, .none):
//                print("no data")
//            case (.none, .some(let error)):
//                print("some error \(error.localizedDescription)")
//            case (.some(let snapshot), _):
//                print("collection updated, now it contains \(snapshot.documents.count) documents")
//            }
//        }
        //TEST:
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
        
        
//        db.collection("menuItems").addSnapshotListener { documentSnapshot, error in
//              guard let document = documentSnapshot else {
//                print("Error fetching document: \(error!)")
//                return
//              }
//              guard let data = document.data() else {
//                print("Document data was empty.")
//                return
//              }
//              print("Current data: \(data)")
//            }
//
//
        
        
        

        
//        db.collection("menuItems").getDocuments { snapshot, error in
//
//            if error == nil {
//                //no problems
//                if let snapshot = snapshot {
//                    //get all the data and make menu items
//                    DispatchQueue.main.async {
//                        //assign the menu items on the main thread
//                        MenuItem.allItems = snapshot.documents.map { item in
//
//                            print("First item is \(item["imageURL"] ?? "")")
//
//                            return MenuItem(id: item.documentID,
//                                            category: item["category"] as? String ?? "",
//                                            imageURL: item["imageURL"] as? String ?? "",
//                                            name: item["name"] as? String ?? "",
//                                            price: item["price"] as? [String] ?? ["unknown"],
//                                            size: item["size"] as? [String] ?? [""])
//                        }
//                    }
//                }
//
//            } else {
//                // handle the error
//                print("ERROR in getting documents.")
//            }
//        }
    }
    

    @IBAction func onClickPhone(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + "4808227146") else { return }
            UIApplication.shared.open(number)
    }
    
}

