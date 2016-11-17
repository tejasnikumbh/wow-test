//
//  CircleExpandAnimator.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//


import UIKit

class CircleExpandAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK:- Properties
    var animationDuration = 0.5
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    // MARK:- AnimatedTransitioning Methods
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from) as! WHomeViewController
        let toViewController = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to) as! WProfileViewController
        let selectedImage = fromViewController.selectedPlayerImageView
        containerView.addSubview(toViewController.view)
        let circleMaskPathInitial = UIBezierPath(ovalIn: (selectedImage?.frame)!)
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        let finalRect = CGRect(x: -(height * 0.5 - width * 0.5), y: 0, width: height, height: height)
        let circleMaskPathFinal = UIBezierPath(rect: finalRect)
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toViewController.view.layer.mask = maskLayer
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
}

extension CircleExpandAnimator: CAAnimationDelegate {
    
    // MARK:- CAAnimationDelegate Methods
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(
            !self.transitionContext!.transitionWasCancelled)
        self.transitionContext?.viewController(
            forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
    }
    
}
