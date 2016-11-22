//
//  WHomeViewController.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import UIKit
import Pulsator

class WHomeViewController: UIViewController {
    
    // MARK:- IBOutlets and Properties
    @IBOutlet weak var firstPlayerImageView: UIImageView!
    @IBOutlet weak var secondPlayerImageView: UIImageView!
    
    @IBOutlet weak var pulsatorFirstBackground: UIView!
    @IBOutlet weak var pulsatorSecondBackground: UIView!
    
    @IBOutlet weak var firstPlayerTrophyOne: UIImageView!
    @IBOutlet weak var firstPlayerTrophyTwo: UIImageView!
    @IBOutlet weak var firstPlayerTrophyThree: UIImageView!
    @IBOutlet weak var firstPlayerTrophyFour: UIImageView!
    
    @IBOutlet weak var secondPlayerTrophyOne: UIImageView!
    @IBOutlet weak var secondPlayerTrophyTwo: UIImageView!
    @IBOutlet weak var secondPlayerTrophyThree: UIImageView!
    @IBOutlet weak var secondPlayerTrophyFour: UIImageView!
    
    var animationIsOn = false
    var selectedPlayerImageView: UIImageView? = nil
    var didLeadChange: Bool? = nil
    
    var pulsator = Pulsator()
    var pulsatorTwo = Pulsator()
    
    // MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let didLeadChange = didLeadChange else { return }
        if didLeadChange {
            let winner = WCompetitionManager.sharedInstance.winnerPlayer()
            let name = (winner?.name)!
            let winRate = Int((winner?.winRate())!*100)
            let dialog = WUIElements.dialog(
                message: "\(name) is the new winner with a win rate of \(winRate)%")
            self.present(dialog, animated: true, completion: nil)
            // Changed and effects shown, so reset it to false again
            self.didLeadChange = false
        }
    }
    
    // MARK:- Setup Methods
    func setupGestureRecognizers() {
        var tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(WHomeViewController.firstPlayerImageTapped(sender:)))
        firstPlayerImageView.addGestureRecognizer(tapGestureRecognizer)
        firstPlayerImageView.isUserInteractionEnabled = true
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(WHomeViewController.secondPlayerImageTapped(sender:)))
        secondPlayerImageView.addGestureRecognizer(tapGestureRecognizer)
        secondPlayerImageView.isUserInteractionEnabled = true
    }
    
    func setupView() {
        pulsator.numPulse = 3
        pulsator.animationDuration = 3.5
        pulsator.radius = UIScreen.main.bounds.width * 0.6
        pulsator.backgroundColor = UIColor.white.cgColor
        pulsatorFirstBackground.layer.addSublayer(pulsator)
        pulsator.start()
        
        pulsatorTwo.numPulse = 3
        pulsatorTwo.animationDuration = 3.5
        pulsatorTwo.radius = UIScreen.main.bounds.width * 0.6
        pulsatorTwo.backgroundColor = UIColor.white.cgColor
        pulsatorSecondBackground.layer.addSublayer(pulsatorTwo)
        pulsatorTwo.start()
        
        firstPlayerImageView.layer.cornerRadius = UIScreen.main.bounds.width * 0.25
        secondPlayerImageView.layer.cornerRadius = UIScreen.main.bounds.width * 0.25
        
        let winner = WCompetitionManager.sharedInstance.winner()
        if winner == 1 {
            let firstImage = UIImage(named: "up")
            let secondImage = UIImage(named: "down")
            setupWinner(firstImage: firstImage!, secondImage: secondImage!)
        } else if winner == 2 {
            let firstImage = UIImage(named: "down")
            let secondImage = UIImage(named: "up")
            setupWinner(firstImage: firstImage!, secondImage: secondImage!)
        }
        firstPlayerImageView.image = WCompetitionManager.sharedInstance.playerOne?.profilePicture
        secondPlayerImageView.image = WCompetitionManager.sharedInstance.playerTwo?.profilePicture
    }
    
    func setupWinner(firstImage: UIImage, secondImage: UIImage) {
        firstPlayerTrophyOne.image = firstImage
        firstPlayerTrophyTwo.image = firstImage
        firstPlayerTrophyThree.image = firstImage
        firstPlayerTrophyFour.image = firstImage
        secondPlayerTrophyOne.image = secondImage
        secondPlayerTrophyTwo.image = secondImage
        secondPlayerTrophyThree.image = secondImage
        secondPlayerTrophyFour.image = secondImage
    }
  
    // MARK:- Selectors
    func firstPlayerImageTapped(sender: UITapGestureRecognizer!) {
        selectedPlayerImageView = firstPlayerImageView
        let profileVC = storyboard?.instantiateViewController(
            withIdentifier: Identifiers.ViewController.WProfile) as! WProfileViewController
        profileVC.player = WCompetitionManager.sharedInstance.playerOne
        profileVC.playerIndex = 1
        profileVC.transitioningDelegate = self
        self.present(profileVC, animated: true, completion: nil)
    }
    
    func secondPlayerImageTapped(sender: UITapGestureRecognizer!) {
        selectedPlayerImageView = secondPlayerImageView
        let profileVC = storyboard?.instantiateViewController(
            withIdentifier: Identifiers.ViewController.WProfile) as! WProfileViewController
        profileVC.player = WCompetitionManager.sharedInstance.playerTwo
        profileVC.playerIndex = 2
        profileVC.transitioningDelegate = self
        self.present(profileVC, animated: true, completion: nil)
    }
    
}

// MARK:- Animated Transition Delegate Methods
extension WHomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleExpandAnimator()
    }
    
    func animationController(
        forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardDismissAnimator()
    }
    
}
