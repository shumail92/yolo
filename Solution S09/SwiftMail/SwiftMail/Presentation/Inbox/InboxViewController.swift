import UIKit

class InboxViewController: UIViewController {
    
    fileprivate let segueIdentifierForViewMailVC = "showViewEmailViewController"
    fileprivate let segueIdentifierForComposeMailVC = "showComposeEmailViewController"
    fileprivate let cellIdentifierForInbox = "inboxTableViewCell"
    
    fileprivate var mailRepository: MailRepository?
    fileprivate var mails: [MailModel] = []
    
    fileprivate var animator: InboxExpandAnimator?
    fileprivate var openingFrame: CGRect?
    
    // MARK: IBOutlets
    @IBOutlet var inboxTableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    // MARK: IBActions
    @IBAction func composeMailButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: segueIdentifierForComposeMailVC, sender: nil)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        loadMails()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewMailViewController,
            let mail = sender as? MailModel {
            destination.model = mail

            destination.modalPresentationStyle = .custom
            destination.transitioningDelegate = self
        }
    }
}

// MARK: Private Methods
extension InboxViewController {
    
    fileprivate func configure() {
        navigationBar.barStyle = .black
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .smTUMBlue
        navigationBar.tintColor = .white
        navigationBar.topItem?.title = "Inbox"
        
        mailRepository = Injector.provideMailRepository()
        
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        
        animator = InboxExpandAnimator()
    }
    
    fileprivate func loadMails() {
        mailRepository?.loadMails(
        success: { mails in
            self.mails = mails
            self.inboxTableView.reloadData()
        }, error: { _ in
            print("Error! Unable to retrieve Mails!")
        })
    }
}

// MARK: UITableViewDataSource
extension InboxViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rectInTableView = tableView.rectForRow(at: indexPath)
        openingFrame = tableView.convert(rectInTableView, to: self.view)
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: segueIdentifierForViewMailVC, sender: mails[indexPath.row])
    }
    
}

// MARK: UITableViewDataSource
extension InboxViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierForInbox, for: indexPath) as! InboxTableViewCell
        
        cell.model = mails[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mails.count
    }
    
}

extension InboxViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let openingFrame = openingFrame else { return nil }
        
        animator?.transitionMode = .present
        animator?.openingFrame = openingFrame
        return animator
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator?.transitionMode = .dismiss
        return animator
    }
}
