import UIKit

class InboxTableViewCell: UITableViewCell {
    @IBOutlet weak var senderImageView: UserImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var model: MailModel? {
        didSet {
            guard let model = model else { return }
            subjectLabel.text = model.subject
            senderLabel.text = model.fromName
            contentLabel.text = model.body
            senderImageView.setImage(fromModel: model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
    }
}

// MARK: Private Methods
extension InboxTableViewCell {
    fileprivate func styleView() {
        senderImageView.layer.cornerRadius = min(senderImageView.bounds.height , senderImageView.bounds.width) / 2.0
    }
}
