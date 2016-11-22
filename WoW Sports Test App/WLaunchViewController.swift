//
//  ViewController.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import UIKit
import Pulsator
import Alamofire

class WLaunchViewController: UIViewController {
    // MARK:- IBOutlets and Properties
    @IBOutlet weak var pulseOrigin: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var getStartedBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loadingLabel: UILabel!
    var pulsator = Pulsator()
    
    // MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard WReachability.isConnectedToNetwork() == true else {
            pulsator.stop()
            pulsator.removeFromSuperlayer()
            let dialog = WUIElements.dialog(
                message: "Please enable Internet Connection")
            self.present(dialog, animated: true, completion: nil)
            return
        }
        
        // Using Networking Manager to handle async calls
        loadingLabel.isHidden = false
        WNetworkingManager.sharedInstance.loadPlayersFromServer(completion: {
            (success) in
            self.loadingLabel.isHidden = true
            if !success {
                self.pulsator.stop()
                self.pulsator.removeFromSuperlayer()
                let dialog = WUIElements.dialog(
                    message: "Unable to sync with server, please try again later")
                self.present(dialog, animated: true, completion: nil)
            } else {
                self.showGetStartedButton()
            }
        })
    }
    
    // MARK:- IBActions
    @IBAction func getStartedTapped(_ sender: UIButton) {
        guard let wHomeVC = storyboard?.instantiateViewController(
            withIdentifier: Identifiers.ViewController.WHome) else { return }
        wHomeVC.modalTransitionStyle = .crossDissolve
        self.present(wHomeVC, animated: true, completion: nil)
    }
    
    // MARK:- Setup Methods
    func setupView() {
        // Hide Get Started
        getStartedButton.isHidden = true
        getStartedButton.alpha = 0.0
        // Setup Pulsator
        pulsator.numPulse = 3
        pulsator.animationDuration = 3.5
        pulsator.radius = UIScreen.main.bounds.width * 0.75
        pulsator.backgroundColor = UIColor.white.cgColor
        pulseOrigin.layer.addSublayer(pulsator)
        pulsator.start()
        // Adjust Constraints
        if WDevices.DeviceType.IS_IPHONE {
            getStartedBottomConstraint.constant = 32.0
        } else {
            getStartedBottomConstraint.constant = 80.0
        }
    }
    
    func showGetStartedButton() {
        UIView.animate(withDuration: 0.6) {
            self.getStartedButton.isHidden = false
            self.getStartedButton.alpha = 1.0
        }
    }

}

