import UIKit

class InboxExpandAnimator: NSObject {
    
    enum ExpandTransitionMode {
        case present
        case dismiss
        
        var duration: TimeInterval {
            switch self {
            case .present:
                return 0.4
            case .dismiss:
                return 0.25
            }
        }
    }
    
    var openingFrame: CGRect = CGRect()
    var transitionMode: ExpandTransitionMode = .present
    
    fileprivate var topView: UIView?        // the top of the view, including the cell which was selected
    fileprivate var bottomView: UIView?     // the bottom of the view, not including the cell which was selected
    fileprivate var cellView: UIView?       // a view white view blocking the content of the underlying viewController during the animation
}


extension InboxExpandAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionMode.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else {
            return transitionContext.completeTransition(false)
        }
        
        let containerView = transitionContext.containerView
        
        switch transitionMode {
        case .present:
            prepareSnapshotViews(fromViewController: fromViewController, toViewController: toViewController, containerView: containerView)
            animate(presentedViewController: toViewController, inContainer: containerView, completion: {(success) in
                
                transitionContext.completeTransition(success)
            })
        case .dismiss:
            animate(dismissedViewController: fromViewController, containerView: containerView, completion: {(success) in
                transitionContext.completeTransition(success)
            })
        }

    }
    
    /**
     This method prepares the instance views (top, cell, bottom) needed for the animation and stores them in the respective properties of InboxExpandAnimator.
     
     - parameters:
        - fromViewController: the source ViewController
        - toViewController: the destination ViewController
        - containerView: the view containerView of the current transtionContext
     */
    private func prepareSnapshotViews(fromViewController: UIViewController, toViewController: UIViewController, containerView: UIView) {
        let fromViewFrame = fromViewController.view.frame
        topView = fromViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(openingFrame.origin.y + openingFrame.height, 0, 0, 0))
        topView?.frame = CGRect(x: 0, y: 0, width: fromViewFrame.width, height: openingFrame.origin.y + openingFrame.height)
        
        bottomView = fromViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(0, 0, fromViewFrame.height - openingFrame.origin.y - openingFrame.height, 0))
        bottomView?.frame = CGRect(x: 0, y: openingFrame.origin.y + openingFrame.height, width: fromViewFrame.width, height: fromViewFrame.height - openingFrame.origin.y - openingFrame.height)
        
        cellView = UIView(frame: openingFrame)
        cellView?.backgroundColor = .white
        
        containerView.addSubview(cellView!)
        containerView.addSubview(topView!)
        containerView.addSubview(bottomView!)
        
    }
    
    private func animate(presentedViewController viewController: UIViewController, inContainer container: UIView, completion: @escaping (Bool) -> () ) {
    
        // prepare animation
        let snapshotView = viewController.view.resizableSnapshotView(from: viewController.view.frame, afterScreenUpdates: true, withCapInsets: .zero)
        snapshotView?.frame = openingFrame
        snapshotView?.alpha = 0.0
        container.addSubview(snapshotView!)
        
        viewController.view.alpha = 0.0
        container.addSubview(viewController.view)

            
        UIView.animate(withDuration: transitionMode.duration , animations: {
            guard let topView = self.topView,
                let bottomView = self.bottomView,
                let cellView = self.cellView
            else {
                return
            }
            
            topView.transform = CGAffineTransform(translationX: 0, y: -topView.frame.height)
            bottomView.transform = CGAffineTransform(translationX: 0, y: bottomView.frame.height)
            
            snapshotView?.alpha = 1.0
            snapshotView?.frame = viewController.view.frame
            cellView.frame = viewController.view.frame
            
        }) { (success) in
            snapshotView?.removeFromSuperview()
            viewController.view.alpha = 1.0
            
            completion(success)
        }
    }
    
    private func animate(dismissedViewController viewController: UIViewController, containerView: UIView, completion: @escaping (Bool) -> () ) {
        
        let snapshotView = viewController.view.resizableSnapshotView(from: viewController.view.bounds, afterScreenUpdates: true, withCapInsets: .zero)
        
        containerView.addSubview(snapshotView!)
        
        viewController.view.alpha = 0
        UIView.animate(withDuration: transitionMode.duration, delay: 0, options: .curveEaseIn, animations: {
            
            guard let topView = self.topView,
                let bottomView = self.bottomView
                else {
                    return
            }
            
            topView.transform = CGAffineTransform.identity
            bottomView.transform = CGAffineTransform.identity
            snapshotView?.frame = self.openingFrame
            snapshotView?.alpha = 0
            
        }) { (success) in
            snapshotView?.removeFromSuperview()
            completion(success)
        }
    }
    
}
