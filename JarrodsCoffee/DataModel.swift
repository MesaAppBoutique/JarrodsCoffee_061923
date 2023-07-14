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

import Foundation

// MARK: - Welcome1Element
struct Welcome1Element {
    let id, category: String
    let menuItems: [MenuItem]
}

// MARK: - MenuItem
struct MenuItem: Codable {
    
    // These items were imported from the JSON that is hosted and referenced here..
    // https://github.com/MesaAppBoutique/JarrodsCoffee/blob/main/JarrodsCoffee/data.json
    var id: String
    var menuItem: String = "" //what is this?
    //let size1: Size1?
    //let size2: Size2?
   // let price1, price2: Double?
   // let size3: String?
    //let price3: Double?
    
    // These properties were referenced in the Local Data model, but not the GitHub JSON data model.  Including all properties until it is determined which are useful and which are cruft.
    var name: String
    var size = [String]()
    var price = [Double]()
    var category: String
    var imageURL: URL
    
    
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
    var priceOption = [Double]()

        init(sizeOption: [String] = [String](), priceOption: [Double] = [Double]()) {
            self.sizeOption = sizeOption
            self.priceOption = priceOption
    }
}




