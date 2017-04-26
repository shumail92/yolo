//
//  Album.swift
//  AlbumApp
//
//  Created by Shumail Mohy ud Din on 4/26/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

struct Album{
    var title, artist, genre, year, coverImageName : String
    
    init(title: String, artist: String, genre: String, year: String, coverImageName: String) {
        self.title = title
        self.artist = artist
        self.genre = genre
        self.year = year
        self.coverImageName = coverImageName
    }
}
