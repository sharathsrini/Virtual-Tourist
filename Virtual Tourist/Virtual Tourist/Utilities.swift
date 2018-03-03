//
//  Utilities.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/01/24.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//

import Foundation

//MARK: - Shuffle Mutable Collections

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}



//MARK: - Removing Object From Array by Value

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
            print("removeObject just removed an object")
        } else {
            print("Couldn't remove the object")
        }
    }
}
