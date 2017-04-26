//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Quirin Schweigert on 3/19/17.
//  Copyright © 2017 TUM. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var roundedImageView: UIRoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
	@IBOutlet var starButton: UIButton!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
	var delegate:StarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func starTapped(_ sender: UIButton) {
		starButton.isHidden = true
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		delegate?.starPressed(in: self)
	}
}
