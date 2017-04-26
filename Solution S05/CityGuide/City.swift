//
//  City.swift
//  CityGuide
//
//  Created by Florian Fittschen on 11/09/15.
//  Copyright © 2015 TUM LS1. All rights reserved.
//

struct City {
    let name: String
    let imageName: String
    let guide: String
    var favorite: Bool
    
    var composedName: String {
        return self.favorite ? self.name + " ❤️" : self.name
    }
}
