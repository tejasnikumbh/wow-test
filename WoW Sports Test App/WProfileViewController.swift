//
//  WProfileViewController.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import UIKit

class WProfileViewController: UIViewController {
    
    // MARK:- IBOutlets and Properties
    @IBOutlet weak var panDownOnboardingIndicator: UIButton!
    @IBOutlet weak var profileCard: UIView!
    @IBOutlet weak var profileCardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileCardBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playerBackgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var trophyView: UIImageView!
    
    var player: WPlayer? = nil
    var playerIndex: Int? = nil
    
    // MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if WDevices.DeviceType.IS_IPAD {
            if WDevices.DeviceType.IS_IPAD_PRO_12_9 {
                profileCardBottomConstraint.constant = 32.0
            } else {
                profileCardBottomConstraint.constant = 32.0
            }
        } else { // IPhone
            profileCardBottomConstraint.constant = 32.0
        }
        UIView.animate(withDuration: 0.6, delay: 0.6, options: [],
                       animations: { self.view.layoutIfNeeded() }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.onboardingDone)
    }
    //MARK:- IBActions
    @IBAction func chooseTapped(_ sender: UIButton) {
        let dialog = WUIElements.dialog(message: "You chose \((self.player?.name)!) as the winner",
            completion: { // Handler for OK Action
                let winnerIndex = WCompetitionManager.sharedInstance.winner()
                if self.playerIndex == 1 { // Win count increases for winner only
                    WCompetitionManager.sharedInstance.playerOne?.winCount
                        = (WCompetitionManager.sharedInstance.playerOne?.winCount)! + 1
                } else {
                    WCompetitionManager.sharedInstance.playerTwo?.winCount
                        = (WCompetitionManager.sharedInstance.playerTwo?.winCount)! + 1
                }
                // Match count for both will increase
                WCompetitionManager.sharedInstance.playerOne?.judgeCount
                    = (WCompetitionManager.sharedInstance.playerOne?.judgeCount)! + 1
                WCompetitionManager.sharedInstance.playerTwo?.judgeCount
                    = (WCompetitionManager.sharedInstance.playerTwo?.judgeCount)! + 1
                let winnerIndexAfterUpdate = WCompetitionManager.sharedInstance.winner()
                let presentingViewController = self.presentingViewController as! WHomeViewController
                presentingViewController.didLeadChange = (winnerIndex != winnerIndexAfterUpdate)
                
                self.dismiss(animated: true, completion: nil)
        })
        self.present(dialog, animated: true, completion: nil)
    }
    
    //MARK:- Setup Methods
    func setupView() {
        if WDevices.DeviceType.IS_IPAD { // IPad
            if WDevices.DeviceType.IS_IPAD_PRO_12_9 {
                profileCardHeightConstraint.constant = 480.0
                profileCardBottomConstraint.constant = -480.0
            } else {
                profileCardHeightConstraint.constant = 380.0
                profileCardBottomConstraint.constant = -380.0
            }
        } else { // IPhone
            profileCardHeightConstraint.constant = 270.0
            profileCardBottomConstraint.constant = -270.0
            winLabel.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: 24.0)
            lossLabel.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: 24.0)
            winRateLabel.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: 24.0)
            rankLabel.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: 24.0)
        }
        // Trophy View being set according to the winner
        guard let winner = WCompetitionManager.sharedInstance.winnerPlayer() else { return }
        guard let player = player else { return }
        if winner.userId == player.userId {
            trophyView.image = UIImage(named: "up") }
        else {
            trophyView.image = UIImage(named: "down") }
        winLabel.text = "\(player.winCount!)"
        lossLabel.text = "\(player.judgeCount! - player.winCount!)"
        winRateLabel.text = "\(Int(player.winRate() * 100))"
        rankLabel.text = "\(player.ranking!)"
        nameLabel.text = player.name!
        playerBackgroundImage.image = player.profilePicture
        startPanDownBlink()
    }
    
    func setupGestureRecognizers() {
        let pan = UIPanGestureRecognizer(
            target: self, action: #selector(WProfileViewController.viewPannedDown(sender:)))
        self.view.addGestureRecognizer(pan)
        self.view.isUserInteractionEnabled = true
    }

    // MARK:- Selectors
    func viewPannedDown(sender: UIPanGestureRecognizer!) {
        let percentThresholdForPanDown:CGFloat = 0.25
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let dProgress = CGFloat(downwardMovementPercent)
        
        if dProgress >= percentThresholdForPanDown {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK:- Util Methods for View Controller
    func startPanDownBlink() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.onboardingDone) { return }
        var newAlpha = 1.0
        if panDownOnboardingIndicator.alpha == 1.0 {
            newAlpha = 0.0
        }
        UIView.animate(withDuration: 1.0, animations: {
            self.panDownOnboardingIndicator.alpha = CGFloat(newAlpha)
        }) { (success) in
            self.startPanDownBlink()
        }
    }
}
