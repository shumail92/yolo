//
//  UIRoundedImageView.swift
//  Contacts
//
//  Created by Quirin Schweigert on 3/18/17.
//  Copyright © 2017 TUM. All rights reserved.
//

import UIKit

class UIRoundedImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        initialize()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }
    
    private func initialize() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.gray.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = max(bounds.width, bounds.height) / 2
    }
}
