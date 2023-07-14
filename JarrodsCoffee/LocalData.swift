////
////  LocalData.swift
////  JarrodsMenuRev
////
////  Created by Jason Carter on 4/4/22.
////
//
//import Foundation
//
//struct LocalData {
//    /// Use local data instead of remote server
//    static let isLocal = true
//
//    /// List of categories
//    static let categories = [
//        "Hot Beverages",
//        "Iced Beverages",
//        "Blended",
//        "Smoothies",
//        "Other Drinks",
//        "Bakery Pastry",
//        "Bulk",
//        ]
//
//    //Local json data for items
//    static let menuItems = [
//
//        MenuItem(
//                    id: 11,
//                    name: "House Coffee",
//                    size: ["12 oz", "16 oz"],
//                    price: [2.50, 3.00],
//                    category: "Hot Beverages",
//                    imageURL: URL(fileURLWithPath: "bags_of_coffee")
//                ),
//        MenuItem(
//                    id: 12,
//                    name: "Americano",
//                    size: ["12 oz", "16 oz"],
//                    price: [3.25, 3.75],
//                    category: "Hot Beverages",
//                    imageURL: URL(fileURLWithPath: "latte")
//                ),
//        MenuItem(
//                     id: 13,
//                     name: "Cappuccino",
//                     size: ["12 oz", "16 oz"],
//                     price: [3.50,4.00],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "cappuccino")
//                 ),
//        MenuItem(
//                     id: 14,
//                     name: "Latte",
//                     size: ["12 oz", "16 oz"],
//                     price: [3.50,4.00],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "latte")
//                 ),
//        MenuItem(
//                     id: 15,
//                     name: "Chai Latte",
//                     size: ["12 oz", "16 oz"],
//                     price: [3.75,4.25],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "bags_of_coffee")
//                ),
//        MenuItem(
//                     id: 16,
//                     name: "Hot Tea",
//                     size: ["12 oz", "16 oz"],
//                     price: [2.50, 3.00],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "latte")
//                 ),
//        MenuItem(
//                     id: 17,
//                     name: "Hot Cocoa",
//                     size: ["12 oz", "16 oz"],
//                     price: [2.50, 3.00],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "bags_of_coffee")
//                 ),
//        MenuItem(
//                     id: 18,
//                     name: "Mocha",
//                     size: ["12 oz", "16 oz"],
//                     price: [2.95, 3.45],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "latte")
//                ),
//         MenuItem(
//                     id: 19,
//                     name: "Espresso Shot",
//                     size: ["12 oz", "16 oz"],
//                     price: [2.50, 3.00],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "bags_of_coffee")
//                ),
//         MenuItem(
//                     id: 110,
//                     name: "Caramel",
//                     size: ["12 oz", "16 oz"],
//                     price: [2.95, 3.45],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "latte")
//                ),
//         MenuItem(
//                     id: 111,
//                     name: "Vanilla",
//                     size: ["12 oz", "16 oz"],
//                     price: [2.95, 3.45],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "latte")
//                ),
//         MenuItem(
//                     id: 112,
//                     name: "Hot Chocolate",
//                     size: ["12 oz", "16 oz"],
//                     price: [2.25, 2.75],
//                     category: "Hot Beverages",
//                     imageURL: URL(fileURLWithPath: "latte")
//                ),
//        MenuItem(
//                    id: 21,
//                    name: "Iced Americano",
//                    size: ["16 oz", "24 oz"],
//                    price: [3.75, 4.25],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "iced_americano")
//                ),
//        MenuItem(
//                    id: 22,
//                    name: "Iced Love a Latte",
//                    size: ["16 oz","24 oz"],
//                    price: [3.75, 4.25],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "iced_lattes")
//                ),
//        MenuItem(
//                    id: 23,
//                    name: "Iced Caramel Latte(Ghiradelli)",
//                    size: ["16 oz", "24 oz"],
//                    price: [4.00, 4.50],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "iced_lattes")
//                ),
//        MenuItem(
//                    id: 24,
//                    name: "Iced Mocha Latte(Ghiradelli)",
//                    size: ["16 oz", "24 oz"],
//                    price: [3.50, 4.00],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "iced_lattes")
//                ),
//        MenuItem(
//                    id: 25,
//                    name: "Iced Vanilla Latte(Ghiradelli)",
//                    size: ["16 oz", "24 oz"],
//                    price: [3.50, 4.00],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "iced_chai_latte")
//                ),
//        MenuItem(
//                    id: 26,
//                    name: "Iced Chai Latte",
//                    size: ["16 oz", "24 oz"],
//                    price: [4.00, 4.50],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "iced_chai_latte")
//                ),
//        MenuItem(
//                    id: 27,
//                    name: "Lemonade",
//                    size: ["16 oz", "24 oz"],
//                    price: [2.50, 3.25],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "lemonade")
//                ),
//        MenuItem(
//                    id: 28,
//                    name: "Shaved Ice",
//                    size: ["16 oz"],
//                    price: [3.00],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "latte")
//                ),
//        MenuItem(
//                    id: 29,
//                    name: "Italian Soda",
//                    size: ["16 oz", "24 oz"],
//                    price: [3.00, 3.50],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "italian_soda")
//                ),
//        MenuItem(
//                    id: 210,
//                    name: "Iced Tea",
//                    size: ["16 oz", "24 oz"],
//                    price: [2.50, 3.25],
//                    category: "Iced Beverages",
//                    imageURL: URL(fileURLWithPath: "iced_tea")
//                ),
//        MenuItem(
//                    id: 31,
//                    name: "Caramel Kick",
//                    size: ["16 oz", "24 oz"],
//                    price: [4.95,  5.75],
//                    category: "Blended",
//                    imageURL: URL(fileURLWithPath: "caramel_kick")
//                ),
//        MenuItem(
//                    id: 32,
//                    name: "Cinnamon Bang",
//                    size: ["16 oz",  "24 oz"],
//                    price: [4.95, 5.75],
//                    category: "Blended",
//                    imageURL: URL(fileURLWithPath: "blended_lattes")
//                ),
//        MenuItem(
//                    id: 33,
//                    name: "Mocha My-day",
//                    size: ["16 oz",  "24 oz"],
//                    price: [4.95, 5.75],
//                    category: "Blended",
//                    imageURL: URL(fileURLWithPath: "mocha_my_day")
//                ),
//        MenuItem(
//                    id: 34,
//                    name: "Vanilla Yum",
//                    size: ["16 oz",  "24 oz"],
//                    price: [4.95, 5.75],
//                    category: "Blended",
//                    imageURL: URL(fileURLWithPath: "blended_lattes")
//                ),
//        MenuItem(
//                    id: 35,
//                    name: "Hazelnut Fun",
//                    size: ["16 oz",  "24 oz"],
//                    price: [4.95, 5.75],
//                    category: "Blended",
//                    imageURL: URL(fileURLWithPath: "blended_lattes")
//                ),
//        MenuItem(
//                    id: 36,
//                    name: "Green Tea D’Lish",
//                    size: ["16 oz",  "24 oz"],
//                    price: [4.95, 5.75],
//                    category: "Blended",
//                    imageURL: URL(fileURLWithPath: "blended_lattes")
//                ),
//        MenuItem(
//                    id: 37,
//                    name: "Chai Oh-Yea",
//                    size: ["16 oz",  "24 oz"],
//                    price: [4.95, 5.75],
//                    category: "Blended",
//                    imageURL: URL(fileURLWithPath: "blended_lattes")
//                ),
//        MenuItem(
//                    id: 38,
//                    name: "Peanutbutter Mocha Blast",
//                    size: ["16 oz",  "24 oz"],
//                    price: [4.95, 5.75],
//                    category: "Blended",
//                    imageURL: URL(fileURLWithPath: "blended_lattes")
//                ),
//        MenuItem(
//                    id: 41,
//                    name: "Straw Bangin Berry",
//                    size: ["16 oz", "24 oz"],
//                    price: [4.75, 5.50],
//                    category: "Smoothies",
//                    imageURL: URL(fileURLWithPath: "straw_bangin_berry")
//                ),
//        MenuItem(
//                    id: 42,
//                    name: "Pina Lota Colada",
//                    size: ["16 oz", "24 oz"],
//                    price: [4.75, 5.50],
//                    category: "Smoothies",
//                    imageURL: URL(fileURLWithPath: "straw_bangin_berry")
//                ),
//        MenuItem(
//                    id: 43,
//                    name: "Blueberry Pomegranate Explosion",
//                    size: ["16 oz", "24 oz"],
//                    price: [4.75, 5.50],
//                    category: "Smoothies",
//                    imageURL: URL(fileURLWithPath: "smoothies")
//                ),
//        MenuItem(
//                    id: 44,
//                    name: "Mango Madness",
//                    size: ["16 oz", "24 oz"],
//                    price: [4.75, 5.50],
//                    category: "Smoothies",
//                    imageURL: URL(fileURLWithPath: "smoothies")
//                ),
//        MenuItem(
//                    id: 45,
//                    name: "Banana Rama",
//                    size: ["16 oz", "24 oz"],
//                    price: [4.75, 5.50],
//                    category: "Smoothies",
//                    imageURL: URL(fileURLWithPath: "smoothies")
//                ),
//        MenuItem(
//                    id: 51,
//                    name: "Black and Blue Iced Tea",
//                    size: ["16 oz", "24 oz", "32 oz"],
//                    price: [2.75, 3.50, 4.50],
//                    category: "Other Drinks",
//                    imageURL: URL(fileURLWithPath: "black_and_blue_iced_tea")
//                ),
//        MenuItem(
//                    id: 52,
//                    name: "Arnold Palmer",
//                    size: ["16 oz", "24 oz", "32 oz"],
//                    price: [2.75, 3.50, 4.50],
//                    category: "Other Drinks",
//                    imageURL: URL(fileURLWithPath: "iced_arnold_palmer")
//                ),
//        MenuItem(
//                    id: 53,
//                    name: "Arnold Palmer",
//                    size: ["16 oz", "24 oz"],
//                    price:[3.00, 3.50],
//                    category: "Other Drinks",
//                    imageURL: URL(fileURLWithPath: "iced_arnold_palmer")
//                ),
//        MenuItem(
//                    id: 54,
//                    name: "Lightning Lemonade",
//                    size: ["16 oz", "24 oz"],
//                    price:[2.50, 3.25],
//                    category: "Other Drinks",
//                    imageURL: URL(fileURLWithPath: "lightning_lemonade")
//                ),
//        MenuItem(
//                    id: 55,
//                    name: "Italian Soda",
//                    size: ["16 oz", "24 oz"],
//                    price:[3.00, 3.50],
//                    category: "Other Drinks",
//                    imageURL: URL(fileURLWithPath: "italian_soda")
//                ),
//        MenuItem(
//                    id: 61,
//                    name: "Bagel with Cream Cheese",
//                    size: ["Single"],
//                    price: [2.25],
//                    category: "Bakery Pastry",
//                    imageURL: URL(fileURLWithPath: "bagel_with_cream_cheese")
//                ),
//        MenuItem(
//                id: 62,
//                name: "Banana Nut Muffin",
//                size: ["Single"],
//                price: [4.95],
//                category: "Bakery Pastry",
//                imageURL: URL(fileURLWithPath: "banana_nut_muffin")
//                ),
//        MenuItem(
//                id: 71,
//                name: "Lemon Strawberry Tea",
//                size: ["Bulk"],
//                price: [12.95],
//                category: "Bulk",
//                imageURL: URL(fileURLWithPath: "lemon_strawberry_tea")
//                ),
//        MenuItem(
//                id: 72,
//                name: "Jarrods Coffe Beans",
//                size: ["Bulk"],
//                price: [12.95],
//                category: "Bulk",
//                imageURL: URL(fileURLWithPath: "jarrods_coffee_beans")
//                ),
//            ]
//        }
////list of addons to be added to order/itemdetailcontrollerview later
////static let addOnItems = [
//// MenuItem(
////        id: 81,
//// name: "Espresso Shot",
////   price1: 0.75
////              ),
////         MenuItem(
////                id: 82,
////          name: "Almond Milk",
////                price1: 0.75
////             ),
////            MenuItem(
////                id: 83,
////                 name: "Soy Milk",
////            price1: 0.75
////         ),
////      MenuItem(
////          id: 84,
////            name: "Coconut Milk",
////             price1: 0.75
////         ),
////        MenuItem(
////            id: 85,
////          name: "Whey Protein",
////       price1: 0.75
////       ),
////        MenuItem(
////            id: 89,
////        name: "Soy Protein",
////         price1: 0.75
////     ),
////         ]
////          }
//
