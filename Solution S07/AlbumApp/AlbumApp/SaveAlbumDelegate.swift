//
//  SaveAlbumDelegate.swift
//  AlbumApp
//
//  Created by Shumail Mohy ud Din on 4/26/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

protocol SaveAlbumDelegate: class {
    func didPressSave(albumG: Album) -> Bool
}
