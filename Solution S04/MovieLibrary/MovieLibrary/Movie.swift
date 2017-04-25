//
//  Movie.swift
//  MovieLibrary
//
//  Created by Shumail Mohy ud Din on 4/25/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    let title: String
    let description: String
    let image: String
    
    init(title: String, description: String, image: String) {
        self.title = title
        self.description = description
        self.image = image
    }
}
