//
//  Array+ArArray.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/25/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


extension Array {
    
    /**
     * @brief grouped
     * @return array
     Using:
     
     struct User { var age = 0 }
     let users: [User] = [User(age: 2), User(age: 4), User(age: 5), User(age: 5), User(age: 2)]
     let groupedUser = users.groupBy { $0.age }
     print(groupedUser)
     */
    func grouped<T: Hashable>(_ groupClosure: (Element) -> T) -> [[Element]] {
        var groups = [[Element]]()
        
        for element in self {
            let key = groupClosure(element)
            var active = Int()
            var isNewGroup = true
            var array = [Element]()
            
            for (index, group) in groups.enumerated() {
                let firstKey = groupClosure(group[0])
                if firstKey == key {
                    array = group
                    active = index
                    isNewGroup = false
                    break
                }
            }
            
            array.append(element)
            
            if isNewGroup {
                groups.append(array)
            } else {
                groups.remove(at: active)
                groups.insert(array, at: active)
            }
        }
        
        return groups
    }
    /**
     * @brief groupBy
     * @return dictionary
     Using :
     
     let numbers = [1, 2, 3, 4, 5, 6]
     let groupedNumbers = numbers.grouped(by: { (number: Int) -> String in
     if number % 2 == 1 {
     return "odd"
     } else {
     return "even"
     }
     })
     result: ["odd": [1, 3, 5], "even": [2, 4, 6]]
     */
    func groupBy<T>(by criteria: (Element) -> T) -> [T: [Element]] {
        var groups = [T: [Element]]()
        for element in self {
            let key = criteria(element)
            if groups.keys.contains(key) == false {
                groups[key] = [Element]()
            }
            groups[key]?.append(element)
        }
        return groups
    }
    
    /**
     * @desc remove duplicate
     */
    func filterDuplicates(_ includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
    
    func getElementBy(_ index: Int) ->Element? {
        if index >= 0 && index < self.count {
            return self[index]
        }
        return nil
    }
}
