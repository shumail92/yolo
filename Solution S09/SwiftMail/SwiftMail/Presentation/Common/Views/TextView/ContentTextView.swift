import UIKit

class ContentTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        font = UIFont(name: "Roboto-Regular", size: 19)
        textColor = UIColor.black.withAlphaComponent(0.8)
    }
    
}
