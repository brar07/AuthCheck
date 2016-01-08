//
//  DetailTransition.swift
//  AuthCheck
//
//  Created by Karanveer Singh Brar on 07/01/16.
//  Copyright © 2016 Karanveer Singh Brar. All rights reserved.
//

import UIKit

class DetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // TODO: Perform the animation
        let detail: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView: UIView = transitionContext.containerView()!
        detail.view.alpha = 0.0
        
        var frame:CGRect = containerView.bounds
        frame.origin.y += 20
        frame.size.height -= 20
        detail.view.frame = frame
        
        containerView.addSubview(detail.view)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            detail.view.alpha = 1.0
            }) { (Bool) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
}
