//
//  DataModel.swift
//  JarrodsCoffee
//
//  Created by David Levy on 7/14/23.
//


import Foundation
import UIKit

struct MenuCategory {
    var key: String
    var image: UIImage
}

struct MenuImage {
    var key: String
    var image: UIImage
}

// MARK: - MenuItem
struct MenuItem {
    
    static var allItems: [MenuItem] = []
    static var allCategories: [String] = []
    static var displayItems: [MenuItem] = []

    var id: String //  UID
    var category: String // category of menu item like beverage, snack, etc.
    var imageURL: String // url of the image to show
    var image: UIImage = UIImage(named: "Iced_Tea")!
    var name: String //  Displayed to User
    var price: [String] // Cooresponding cost for small medium or large
    var size: [String] //  Small medium large, for example
    
    mutating func loadImage() -> MenuImage {
        // Configure menuImage
            for thisImage in MenuControl.shared.downloadedImages {
                if thisImage.key == imageURL {
                            return thisImage
                        }
                }
        return MenuImage(key: "imageURL", image: UIImage(named: "Iced_Tea")!)
    }
    
    func loadCategory() -> MenuCategory {
        
        for thisImage in MenuControl.shared.downloadedImages {
            
            //Can we find an image for this category?
            if thisImage.key == category {
                return MenuCategory(key: thisImage.key, image: thisImage.image)
                    }
            }
        
    return MenuCategory(key: category, image: UIImage(named: "Image")!)
    }
    
    static func loadCategories() {
        // Add to list of categories
        for eachItem in MenuItem.allItems {
            if !MenuItem.allCategories.contains(eachItem.category) { MenuItem.allCategories.append(eachItem.category) }

        }
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




