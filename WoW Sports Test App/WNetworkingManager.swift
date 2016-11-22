//
//  WNetworkingManager.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 22/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import Foundation
import Alamofire

typealias WNetworkCallCompletion = (_ success: Bool) -> ()

final class WNetworkingManager: Singleton {
    
    static let sharedInstance = WNetworkingManager()
    // Ensures that instances of this aren't created
    fileprivate init() {}
    
    private var sessionManager : Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "test.wowjust.watch": .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let man = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return man
    }()
    
    /*
     * Method: loadPlayersFromServer:completion
     *
     * Discussion: Method that downloads player data from JSON API
     */
    func loadPlayersFromServer(completion: @escaping (_ success: Bool) -> ()) {
        sessionManager.request("https://test.wowjust.watch/test.json").responseJSON{ response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            guard let JSON = response.result.value else {
                completion(false)
                return
            }
            let result = (JSON as! [String: AnyObject])["people"]
            guard let people = result as? [AnyObject] else {
                completion(false)
                return
            }
            guard let playerOne = people[0] as? [String: AnyObject],
                let playerTwo = people[1] as? [String: AnyObject] else {
                    completion(false)
                    return
            }
            guard let wPlayerOne = WPlayer(player: playerOne),
                let wPlayerTwo = WPlayer(player: playerTwo) else {
                completion(false)
                return
            }
            self.imageDownloader(
                playerOne: wPlayerOne, playerTwo: wPlayerTwo,
                completion: { (success) in
                if success {
                    WCompetitionManager.sharedInstance.playerOne = wPlayerOne
                    WCompetitionManager.sharedInstance.playerTwo = wPlayerTwo
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    /*
     * Method: imageDownloader
     *
     * Discussion: Method that downloads images and notifies the main thread 
     * once this is done. Especially useful since once this is done, we can
     * be sure that all data for app to be functional is ready
     */
    func imageDownloader (
        playerOne: WPlayer, playerTwo: WPlayer,
        completion: @escaping WNetworkCallCompletion) {
        let backgroundQ = DispatchQueue.global(qos: .default)
        let group = DispatchGroup()
        
        // Enqueuing a task in the Dispatch Group
        group.enter()
        backgroundQ.async(group: group,  execute: {
            playerOne.fetchProfileImage(completion: { (success) in
                group.leave()
            })
        })
        // Enqueuing a task in the Dispatch Group
        group.enter()
        backgroundQ.async(group: group, execute: {
            playerTwo.fetchProfileImage(completion: { (success) in
                group.leave()
            })
        })
        // Code to be executed after the tasks complete
        group.notify(queue: DispatchQueue.main, execute: {
            print("All Done")
            completion(true)
        }) 
    }
}
