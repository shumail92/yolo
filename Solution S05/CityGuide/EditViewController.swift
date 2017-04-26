//
//  EditViewController.swift
//  CityGuide
//
//  Created by Shumail Mohy ud Din on 4/26/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var guideTextView: UITextView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    weak var delegate: SaveCityDelegate?
    var city: City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guideTextView.text = city.guide
        favoriteSwitch.isOn = city.favorite
        guideTextView.delegate = self;
    }
    
    @IBAction func saveCity() {
        if (guideTextView.text.isEmpty) {
            let alert = UIAlertController(title: "Error!", message: "Guide cannot be empty. Try again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        city.guide = guideTextView.text
        city.favorite = favoriteSwitch.isOn
        
        if let success = delegate?.didPressSave(cityG: city), success {
            _ = navigationController?.popViewController(animated: true)
        }
    }
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            view.endEditing(true)
            return false
        }
        return true
    }
}
