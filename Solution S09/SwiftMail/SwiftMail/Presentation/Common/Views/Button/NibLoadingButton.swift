import UIKit

protocol NibDefinable {
    var nibName: String { get }
}

/**
 * Subclass your UIButton from NibLoadingButton to automatically load a xib with the same name as your class
 */
@IBDesignable class NibLoadingButton: UIButton {
    
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
        initialize()
    }
    
    /**
     * Do any additional setup after loading the view from the nib
     */
    internal func initialize() {
        // override in subclass
    }
    
    private func nibSetup() {
        backgroundColor = UIColor.clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
}


extension NibLoadingButton: NibDefinable {
    var nibName: String {
        return String(describing: type(of: self))
    }
}
