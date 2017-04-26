//
//  DetailViewController.swift
//  AlbumApp
//
//  Created by Shumail Mohy ud Din on 4/26/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var album: Album!
    
    @IBOutlet weak var artistTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var genreTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var albumImage: UIImageView!
    weak var delegate: SaveAlbumDelegate?
    
    @IBOutlet weak var navTitle: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle.title = album.title
        artistTF.text = album.artist
        titleTF.text = album.title
        genreTF.text = album.genre
        yearTF.text = album.year
        albumImage.image = UIImage(named: album.coverImageName)!
        artistTF.delegate = self
        titleTF.delegate = self
        genreTF.delegate = self
        yearTF.delegate = self
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        let editedAlbum = Album(title: titleTF.text!, artist: artistTF.text!, genre: genreTF.text!, year: yearTF.text!, coverImageName: (album?.coverImageName)!)
        
        if let success = delegate?.didPressSave(albumG: editedAlbum), success {
            print("Saved successfully")
        }
        else {
            print("Editing unsuccessful")
        }
    }
}
