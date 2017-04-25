import UIKit

class LaunchScreenViewController: UIViewController {
    // TODO 1: Add the Logo to the Launchscreen.storyboard, so the logo is displayed as soon as the user starts the app. Make sure the image is properly drawn
    // TODO 2: Add the same ImageView with the same constraints from the Launchscreen to the LaunchScreenViewController in the Interface Builder
    fileprivate let segueIdentifierForViewMailVC = "showInboxViewController"

    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO 3: Animate the logo and open the InboxViewController when the animation is completed
        // The animation must consist of at least two separate transformations (rotate, scale, translate). Other than that you can be creative. E.g. rotate the bird up and make it move through the top.
                
        UIView.animateKeyframes(withDuration: 2.5, delay: 0, options: .calculationModePaced, animations: {
        
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.logo.transform = self.logo.transform.concatenating(CGAffineTransform(rotationAngle: CGFloat.pi))
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5 , animations: {
               self.logo.transform = self.logo.transform.concatenating(CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height/2 + (self.logo.image?.size.height)!/2)))
            })
        }, completion: {
            _ in self.performSegue(withIdentifier: self.segueIdentifierForViewMailVC, sender: nil)
        })
        
    }
}
