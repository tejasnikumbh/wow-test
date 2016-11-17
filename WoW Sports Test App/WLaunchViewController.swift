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
import AlamofireImage

class WLaunchViewController: UIViewController {
    // MARK:- IBOutlets and Properties
    @IBOutlet weak var pulseOrigin: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var getStartedBottomConstraint: NSLayoutConstraint!
    
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
        
        loadPlayersFromServer(completion: {
            (success) in
            if !success {
                self.pulsator.stop()
                self.pulsator.removeFromSuperlayer()
                let dialog = WUIElements.dialog(
                    message: "Unable to sync with server, please try again later")
                self.present(dialog, animated: true, completion: nil)
            } else { self.showGetStartedButton() }
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
    
    // MARK:- Util Methods for View Controller
    func loadPlayersFromServer(completion: @escaping (_ success: Bool) -> ()) {
        // Currently instantiating static player instances since Web API Not working
        let federer = WPlayer(userId: 32, name: "Roger Federer", ranking: 2, profilePicture: UIImage(named:"federer")!, profilePictureURL: "https://upload.wikimedia.org/wikipedia/commons/3/3c/Roger_Federer_%2826_June_2009%2C_Wimbledon%29_2_new.jpg", winCount: 3, judgeCount: 5, otherImageURLs: ["http://e2.365dm.com/16/01/16-9/20/roger-federer-atp-tennis_3396787.jpg?20160108131527", "http://d.ibtimes.co.uk/en/full/1457562/roger-federer.jpg"])
        let nadal = WPlayer(userId: 12, name: "Rafael Nadal", ranking: 1, profilePicture: UIImage(named:"nadal")!, profilePictureURL: "https://upload.wikimedia.org/wikipedia/commons/2/2f/Rafael_Nadal_January_2015.jpg", winCount: 10, judgeCount: 12, otherImageURLs: ["http://wpc.e0ad.edgecastcdn.net/00E0AD/images/the-philippine-star/sports/20150624/PS-Nadal.jpg", "http://i.dailymail.co.uk/i/pix/2015/06/02/12/2941A10000000578-0-image-a-78_1433246116261.jpg"])
        WCompetitionManager.sharedInstance.playerOne = federer
        WCompetitionManager.sharedInstance.playerTwo = nadal
        // Delay for simulating loading of players
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            completion(true)
        })
    }
    
    func showGetStartedButton() {
        UIView.animate(withDuration: 0.6) {
            self.getStartedButton.isHidden = false
            self.getStartedButton.alpha = 1.0
        }
    }

}

