import UIKit

class FloatingButton: NibLoadingButton {
    
    @IBOutlet var customImageView: UIImageView!
    
    @IBInspectable var icon: UIImage? {
        didSet {
            guard let icon = icon else {
                customImageView?.image = nil
                return
            }
            customImageView?.image =  icon.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBInspectable var iconColor: UIColor = .white {
        didSet {
            customImageView?.tintColor = iconColor
        }
    }
    
    @IBInspectable var circleColor: UIColor = .smTUMBlue {
        didSet {
            view?.backgroundColor = circleColor
        }
    }
    
    
    
    // MARK: Lifecycle
    override func initialize() {
        super.initialize()
        
        // Disable userInteraction for the view property, so calls are passed to the actual button.
        view.isUserInteractionEnabled = false
        
        styleView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.layer.cornerRadius = min(view.bounds.height , view.bounds.width) / 2.0
        addShadow(toView: view)
    }
}

// MARK: Private Methods
extension FloatingButton {
    fileprivate func styleView() {
        backgroundColor = UIColor.clear
        titleLabel?.removeFromSuperview()
        imageView?.removeFromSuperview()
        
        view.backgroundColor = circleColor
        customImageView.tintColor = .white
    }
    
    fileprivate func addShadow(toView view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.23
        view.layer.shadowRadius = 3.0
        view.layer.shadowOffset = CGSize(width: -1.2, height: 2.0)
    }
}
