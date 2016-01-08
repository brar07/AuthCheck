//
//  DismissDetail.swift
//  AuthCheck
//
//  Created by Karanveer Singh Brar on 07/01/16.
//  Copyright © 2016 Karanveer Singh Brar. All rights reserved.
//

import UIKit

class DismissDetail: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let detail: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            detail.view.alpha = 0.0
            }) { (Bool) -> Void in
                detail.view.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
}
