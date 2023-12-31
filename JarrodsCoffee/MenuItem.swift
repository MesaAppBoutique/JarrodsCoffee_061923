//
//  MenuItem.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import Foundation


struct MenuItem: Codable {
    var id: Int
    var name: String
    var size = [String]()
    var price = [Double]()
    var category: String
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case size
        case price
        case category
        case imageURL = "image_url"
    }
}

struct MenuItems: Codable {
    let items: [MenuItem]
}

struct OptionModel {
    var sizeOption = [String]()
    var priceOption = [Double]()
    
        init(sizeOption: [String] = [String](), priceOption: [Double] = [Double]()) {
            self.sizeOption = sizeOption
            self.priceOption = priceOption
        }
    }


