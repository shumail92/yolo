//
//  ThreadSafeDictionary.swift
//  Contacts
//
//  Created by Quirin Schweigert on 3/17/17.
//  Copyright © 2017 TUM. All rights reserved.
//

import Foundation

public struct ThreadSafeDictionary <Key: Hashable, Value>: Sequence {
    // delegation is used instead of inheritance in order to keep this struct as simple as possible for
    // the purpose of this tutorial
    private var dictionary: [Key : Value] = [:]
    
    private let internalQueue = DispatchQueue(label: "de.tum.www1.ProfBook.ThreadSafeDictionary", attributes: .concurrent)
    
    /*  
     *  The following code makes the subscript (access of the dictionary with square brackets,
     *  e.g. myDictionary["key"] = "value"; print(myDictionary["key"]) work. In case you are
     *  interested you can find more information here:
     *  https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Subscripts.html
     */
    public subscript(key: Key) -> Value? {
        get {
            return internalQueue.sync {
                self.dictionary[key]
            }
        }
        
        mutating set {
            internalQueue.sync(flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
    }
    
    /*
     * The following code implements the requirements to use the for in loop on the dictionary
     */
    public func makeIterator() -> DictionaryIterator<Key, Value> {
        return internalQueue.sync {
            self.dictionary.makeIterator()
        }
    }
}
