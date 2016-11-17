//
//  WUtils.swift
//  WoW Sports Test App
//
//  Created by Tejas  Nikumbh on 17/11/16.
//  Copyright © 2016 Tejas  Nikumbh. All rights reserved.
//

import UIKit

class WUIElements {
    
    /* 
     * Method : dialog
     *
     * Discussion: Returns a simple display dialog alert view controller
     */
    static func dialog(title: String? = "WoW Sports", message: String,
                       completion: WEmptyAlias? = nil) -> UIAlertController {
        let dialog = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: {
                (alertAction) in
                guard let completion = completion else { return }
                completion()
        })
        dialog.addAction(ok)
        return dialog
    }
    
}
