import UIKit

class UserImageView: UIImageView {
    
    fileprivate var model: MailModel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(MailModel.thumbnail) {
            DispatchQueue.main.async {
                self.updateImage()
            }
        }
    }
    
    func setImage(fromModel model: MailModel) {
        // remove self as observer from the old model
        self.model?.removeObserver(self, forKeyPath: #keyPath(MailModel.thumbnail))
        
        self.model = model
        // listen for changes on the models image
        self.model?.addObserver(self, forKeyPath: #keyPath(MailModel.thumbnail), options: NSKeyValueObservingOptions.new, context: nil)
        updateImage()
    }
}

// MARK: Private Methods
extension UserImageView {
    fileprivate func styleView() {
        layer.cornerRadius = min(bounds.height , bounds.width) / 2.0
    }
    
    fileprivate func updateImage() {
        guard let model  = model else { return}
        // if the sender has no image, setup an alternative with his initials
        if let senderImage = model.thumbnail {
            image = senderImage
        } else {
            image = createImageFromText(from: model.fromName, with: frame.size)
            backgroundColor = UIColor.fromString(name: model.fromName)
        }
    }
    
    private func createImageFromText(from text: String,with size: CGSize) -> UIImage {
        //initializing the text properties
        let textColor = UIColor.white
        let textFont = UIFont(name: "Roboto-Bold", size: 19)!
        let senderInitials = extractInitials(from: text)
        //calculating the text position within the imageView
        let textSize = senderInitials.size(attributes: [NSFontAttributeName: textFont])
        let yOffset = (size.height - textSize.height) / 2.0;
        let xOffset = (size.width - textSize.width) / 2.0;
        //drawing the text as an image
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        let rect = CGRect(x: xOffset, y: yOffset, width: size.width, height: textSize.height)
        senderInitials.draw(in: rect, withAttributes: textFontAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     * extracts and returns the first letters of each word
     */
    private func extractInitials(from name: String) -> NSString {
        let initials = name.components(separatedBy: " ").map({$0.characters.first}).flatMap({$0}).map({String($0)}).joined()
        
        return NSString(string: initials)
    }
}
