//
//  WPlayer.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class WPlayer {
    
    var userId: Int? = nil
    var ranking: Int? = nil
    var name: String? = nil
    var profilePictureURL: String? = nil
    var profilePicture: UIImage? = nil
    var winCount: Int? = nil
    var judgeCount: Int? = nil
    var otherImageURLs: [String]? = nil
    var otherImages: [UIImage]? = nil
    
    init(userId: Int, name: String, ranking: Int, profilePictureURL: String,
         winCount: Int, judgeCount: Int, otherImageURLs: [String]) {
        self.userId = userId
        self.ranking = ranking
        self.name = name
        self.profilePictureURL = profilePictureURL
        self.winCount = winCount
        self.judgeCount = judgeCount
        self.otherImageURLs = otherImageURLs
    }
    
    /*
     * Method: convienience init
     *
     * Discussion: Convienience initializer that initializes a JSON Object from response returned
     */
    convenience init?(player: [String: AnyObject]) {
        guard let userId = player["userId"] as? String,
            let name = player["name"] as? String,
            let profilePictureURL = player["profilePicture"] as? String,
            let ranking = player["ranking"] as? Int,
            let winCount = player["winCount"] as? Int,
            let judgeCount = player["judgeCount"] as? Int,
            let otherImageURLs = player["images"] as? [String] else { return nil }
        self.init(userId: Int(userId)!, name: name, ranking: ranking, profilePictureURL: profilePictureURL, winCount: winCount,judgeCount: judgeCount, otherImageURLs: otherImageURLs)
    }
    
    /*
     * Method: winRate
     *
     * Discussion: Method that computes winRate geiven winCounts and judgeCounts
     */
    func winRate() -> Double {
        guard let winCount = self.winCount, let judgeCount = judgeCount else { return -1.0 }
        return Double(winCount) / Double(judgeCount)
    }
    
    /* 
     * Method: fetchProfileImage
     *
     * Discussion: Method that fetches a profile image given a particular URL
     */
    func fetchProfileImage(completion: WNetworkCallCompletion? = nil) {
        guard let profilePictureURL = self.profilePictureURL else { return }
        Alamofire.request(profilePictureURL).responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.profilePicture = image
                guard let completion = completion else { return }
                completion(true)
            } else {
                guard let completion = completion else { return }
                completion(false)
            }
        }
    }
    
    func fetchOtherImages(completion: WNetworkCallCompletion? = nil) {}
    
}
