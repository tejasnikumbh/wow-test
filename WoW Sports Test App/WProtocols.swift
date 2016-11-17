//
//  WProtocols.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import Foundation

protocol Singleton: class {
    static var sharedInstance: Self { get }
}
