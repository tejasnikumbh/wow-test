//
//  CardDismissAnimator.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import UIKit

class CardDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK:- Properties
    var duration = 0.6
    
    // MARK:- Animated Transitioning Methods
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        _ = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from)! as! WProfileViewController
        let initialFrame = fromView.frame
        
        let finalFrame = CGRect(x: 0,
                                y: UIScreen.main.bounds.height,
                                width: initialFrame.width,
                                height: initialFrame.height)
        
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: fromView)
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0.0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    fromView.frame = finalFrame
                })
                
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
