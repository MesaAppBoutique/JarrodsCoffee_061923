//
//  DataModel.swift
//  JarrodsCoffee
//
//  Created by David Levy on 7/14/23.
//

// This file was generated from JSON Schema using codebeautify, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome1 = try Welcome1(json)
// https://github.com/MesaAppBoutique/JarrodsCoffee/blob/main/JarrodsCoffee/data.json

import Foundation


// MARK: - MenuItem
struct MenuItem: Codable {
    
    static var allItems: [MenuItem] = []
    
    var id: String //UID
    var category: String // category of menu item like beverage, snack, etc.
    var imageURL: String // url of the image to show
    var name: String //Displayed to User
    var price: [String] // Cooresponding cost for small medium or large
    var size: [String] //Small medium large, for example

    
    // This was included also in the local data model. May not be needed for Firebase cloud data.
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case size
//        case price
//        case category
//        case imageURL = "image_url"
//    }
    
    
        
    
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




