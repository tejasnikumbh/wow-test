//
//  WConstants.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import Foundation

typealias WEmptyAlias = () -> ()

struct Identifiers {
    struct ViewController{
        static let WLaunch = "WLaunchViewControllerIdentifier"
        static let WHome = "WHomeViewControllerIdentifier"
        static let WProfile = "WProfileViewControllerIdentifier"
    }
}

struct UserDefaultsKeys {
    static let onboardingDone = "WOnboardingDoneKey"
}
