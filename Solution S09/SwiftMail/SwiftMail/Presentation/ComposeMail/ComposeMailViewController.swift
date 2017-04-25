import UIKit

class ComposeMailViewController: UIViewController {
    // TODO 4: Using a vertical StackView, add a Recipient field, a subject field and a TextView for the email content
    // TODO 4.1: The recipient field should be grouped next to a "To" label in another StackView. The field should use "EmailTextField" as a custom class, and the label the "SubheaderLabel" class
    // TODO 4.2: Apply the "SubjectTextField" class to the subject field
    // TODO 4.3: Apply the "ContentTextView" class to the TextView
    
    // TODO 5: Add a send button to the right of the navigation bar (using the send image from the assets catalogue)
    // TODO 6: Add a send floating button to the ViewController with the same position and size as in the InboxViewController
    // TODO 7: Both buttons should validate each editable text and display a warning if applicable. If everything is correctly filled out dismissing the ViewController suffices as a "send"
    
    // MARK: IBActions
    @IBOutlet weak var toEmail: EmailTextField!
    @IBOutlet weak var emailSubject: SubjectTextField!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        
        guard let emailText = self.toEmail.text, emailText != "" else {
            showWarning()
            return
        }
        guard let subjectText = self.emailSubject.text, subjectText != "" else {
            showWarning()
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func showWarning() {
        let alert = UIAlertController(title: "Warning", message: "Invalid Input. Email, Subject can't be empty", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
