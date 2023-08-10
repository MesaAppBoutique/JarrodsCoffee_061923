//
//  Array.swift
//  JarrodsCoffee
//
//  Created by David Levy on 8/10/23.
//

//https://stackoverflow.com/questions/37517829/get-distinct-elements-in-an-array-by-object-property
//Here is an Array extension to return the unique list of objects based on a given key:

extension Array {
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
