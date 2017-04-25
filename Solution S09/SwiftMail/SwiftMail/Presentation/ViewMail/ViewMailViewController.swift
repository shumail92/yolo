import UIKit

class ViewMailViewController: UIViewController {
    
    var model: MailModel?
    
    // MARK: IBOutlets
    @IBOutlet var senderImageView: UserImageView!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var senderLabel: SubheaderLabel!
    @IBOutlet var receiverLabel: ContentLabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var navigationBar: UINavigationBar!
    
     // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
        // MARK: IBActions
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        // Stub: Not implemented for this demo
    }
    
    @IBAction func replyButtonPressed(_ sender: Any) {
        // Stub: Not implemented for this demo
    }

    @IBAction func forwardButtonPressed(_ sender: UIBarButtonItem) {
        // Stub: Not implemented for this demo
    }
    
}

// MARK: Private Methods
extension ViewMailViewController {
    
    fileprivate func configure() {
        updateView()
    }
    
    fileprivate func updateView() {
        guard let model = model else { return }
        senderImageView.setImage(fromModel: model)
        subjectLabel?.text = model.subject
        senderLabel?.text = String.init(format: "%@ <%@>", model.fromName, model.from)
        receiverLabel?.text = model.to
        contentTextView.text = model.body
        
        navigationBar.barStyle = .black
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.fromString(name: model.fromName)
        navigationBar.tintColor = .white
    }
}
