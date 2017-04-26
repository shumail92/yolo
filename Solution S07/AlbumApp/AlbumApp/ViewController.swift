//
//  ViewController.swift
//  AlbumApp
//
//  Created by Shumail Mohy ud Din on 4/26/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var albumTable: UITableView!
    var currentIndex: Int = 0
    
    fileprivate var albumArray = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTable.dataSource = self
        albumTable.delegate = self
        initializeData()
    }
    
    private let a1 = Album(title: "Frozen", artist: "Shumail", genre: "Trance", year: "2012", coverImageName: "cover1")
    private let a2 = Album(title: "Shakira", artist: "Brugge", genre: "yoyo", year: "2013", coverImageName: "cover2")
    private let a3 = Album(title: "She looks so perfect", artist: "Me", genre: "Rock", year: "2012", coverImageName: "cover3")
    private let a4 = Album(title: "In the lonely Hour", artist: "Armin", genre: "Trance", year: "2011", coverImageName: "cover4")
    private let a5 = Album(title: "Spring Yolo", artist: "Armin", genre: "Blah", year: "2989", coverImageName: "cover5")
    private let a6 = Album(title: "Divergent", artist: "Professor", genre: "Tala", year: "3989", coverImageName: "cover6")
    
    private func initializeData() {
        albumArray = [a1, a2, a3, a4, a5, a6]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editAlbum" ) {
            if let tableVC = segue.destination as? DetailViewController {
                tableVC.album = albumArray[currentIndex]
                tableVC.delegate = self
            }
        }

    }
    
    @IBAction func unwindToViewController(_ sender: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albumTable?.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AlbumCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = albumArray[indexPath.row].title
        cell.detailTextLabel?.text = albumArray[indexPath.row].artist
        cell.imageView?.image = UIImage(named: albumArray[indexPath.row].coverImageName)
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ind = tableView.indexPathForSelectedRow?.row{
            currentIndex = ind
            self.performSegue(withIdentifier: "editAlbum", sender: self)
        }
    }
}
extension ViewController: SaveAlbumDelegate {
    func didPressSave(albumG: Album) -> Bool {
        albumArray[currentIndex] = albumG
        return true
    }
}
