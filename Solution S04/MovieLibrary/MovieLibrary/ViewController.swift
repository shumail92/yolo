//
//  ViewController.swift
//  MovieLibrary
//
//  Created by Shumail Mohy ud Din on 4/25/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    private var movies = [Movie]()
    private var currentMovie = 0
    
    private let m1 = Movie(title: "Interstellar", description: "Earth's future has been riddled by disasters, famines, and droughts. There is only one way to ensure mankind's survival: Interstellar travel. A newly discovered wormhole in the far reaches of our solar system allows a team of astronauts to go where no man has gone before, a planet that may have the right environment to sustain human life", image: "interstellar-poster")
    private let m2 = Movie(title: "Inception", description: "A thief, who steals corporate secrets through use of dream-sharing technology, is given the inverse task of planting an idea into the mind of a CEO.", image: "inception-poster")
    private let m3 = Movie(title: "Fight Club", description: "An insomniac office worker, looking for a way to change his life, crosses paths with a devil-may-care soap maker, forming an underground fight club that evolves into something much, much more", image: "fightclub-poster")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeData() {
            self.movies = [m1, m2, m3]
    }
    
    private func updateView() {
        movieTitle.text = self.movies[self.currentMovie].title
        movieDescription.text = self.movies[self.currentMovie].description
        movieImage.image = UIImage(named: self.movies[self.currentMovie].image)
        
    }

    @IBAction func nextMovie() {
        currentMovie = (currentMovie + 1) % movies.count
        updateView()
    }

}

