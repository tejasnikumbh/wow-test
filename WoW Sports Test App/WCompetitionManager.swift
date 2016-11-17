//
//  WCompetitionManager.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import Foundation

final class WCompetitionManager: Singleton {
    
    static let sharedInstance = WCompetitionManager()
    // Ensures that instances of this aren't created
    fileprivate init() {}
    
    var playerOne: WPlayer? = nil
    var playerTwo: WPlayer? = nil
    
    /*
     * Method: winner
     *
     * Discussion: Returns the index of the winner [1st means Top, 2nd means Bottom]
     */
    func winner() -> Int {
        guard let playerOne = playerOne, let playerTwo = playerTwo else { return -1 }
        if (playerOne.winRate() > playerTwo.winRate()) {
            playerOne.ranking = 1
            playerTwo.ranking = 2
            return 1
        } else {
            playerTwo.ranking = 1
            playerOne.ranking = 2
            return 2 }
    }
    
    /* 
     * Method: winnerPlayer
     * 
     * Discussion: Returns the actual player object that is the winner
     */
    func winnerPlayer() -> WPlayer? {
        guard let playerOne = playerOne, let playerTwo = playerTwo else { return nil }
        if (playerOne.winRate() > playerTwo.winRate()) {
            playerOne.ranking = 1
            playerTwo.ranking = 2
            return playerOne
        } else {
            playerTwo.ranking = 1
            playerOne.ranking = 2
            return playerTwo }
    }
}
