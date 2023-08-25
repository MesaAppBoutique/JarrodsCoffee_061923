//
//  DataModel.swift
//  JarrodsCoffee
//
//  Created by David Levy on 7/14/23.
//


import Foundation
import UIKit

struct MenuCategory {
    var id: String = UUID().uuidString
    var name: String = ""
    var imageURL: String = ""
    var image: UIImage = UIImage(named: "Image")!
    
    static let shared = MenuCategory()
    
    func loadCategory(withId id: String) -> MenuCategory {

        //Look for category in cloud data
        
        //Look for image in downloaded images
        
        //create a menu category for this uid
        
        //Can we find an image for this category with the name of x?
        let foundImage = AppData.shared.assignImage(withKey: id)
        let category = MenuCategory(id: id, name: "name", imageURL: "url", image: UIImage(named: "Iced_Tea")!)
        return category
    }
   
    func loadCategories() {
        //just the cateogry uid strings
        MenuItem.shared.categories = []
        // Add to list of categories
//         let itemsWithUniqueCategories = MenuItem.allItems.unique{$0.category}
//         for each in itemsWithUniqueCategories { //ew.  But it at least adds all unique categories
//
//             let newCategory = MenuCategory(
//
//             MenuItem.categories.append(each)
//         }
        
        //bringing in an array of category objects
        AppData.shared.fetchCategories { categories in
            print("Categories have been fetched.")
        }
        
        
        
    
    }
    
}

struct MenuImage {
    var key: String
    var image: UIImage
}

// MARK: - MenuItem
struct MenuItem {
    static var shared = MenuItem()
    var allItems: [MenuItem] = []
//    static var categoryIds: [String] = []
    var categories: [MenuCategory] = []
    var displayItems: [MenuItem] = []

    var id: String = ""//  UID
    var categoryId: String = "" // category of menu item like beverage, snack, etc.
    var imageURL: String = ""// url of the image to show
    var image: UIImage = UIImage(named: "Iced_Tea")!
    var name: String = ""//  Displayed to User
    var price: [String] = []// Cooresponding cost for small medium or large
    var size: [String] = [] //  Small medium large, for example
    
    mutating func loadImage() -> MenuImage {
        // Configure menuImage
            for thisImage in AppData.shared.downloadedImages {
                if thisImage.key == imageURL {
                            return thisImage
                        }
                }
        return MenuImage(key: "imageURL", image: UIImage(named: "Iced_Tea")!)
    }
    
    
}



// This was included also in the local data model.

struct OptionModel {
    var sizeOption = [String]()
    var priceOption = [String]()

        init(sizeOption: [String] = [String](), priceOption: [String] = [String]()) {
            self.sizeOption = sizeOption
            self.priceOption = priceOption
    }
}




