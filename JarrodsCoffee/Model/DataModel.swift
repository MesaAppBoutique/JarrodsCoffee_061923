//
//  DataModel.swift
//  JarrodsCoffee
//
//  Created by David Levy on 7/14/23.
//


import Foundation
import UIKit



struct MenuImage {
    var imageURL: String
    var image: UIImage
}

// MARK: - MenuItem
struct MenuItem {
    
    static var allItems: [MenuItem] = []
    
    var id: String //  UID
    var category: String // category of menu item like beverage, snack, etc.
    var imageURL: String // url of the image to show
    var image: UIImage = UIImage(named: "Iced_Tea")!
    var name: String //  Displayed to User
    var price: [String] // Cooresponding cost for small medium or large
    var size: [String] //  Small medium large, for example
    
    mutating func loadImage() -> MenuImage {
            for thisImage in MenuController.shared.downloadedImages {
                if thisImage.imageURL == imageURL {
                            return thisImage
                        }
                }
        return MenuImage(imageURL: "imageURL", image: UIImage(named: "Iced_Tea")!)
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




