//
//  UIAlertController+Convenience.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import UIKit

public typealias ActionBlock = (_ action: UIAlertAction) -> Void

extension UIAlertController {
    
    open class func alert(title: String?, message:String?, actions:Array<UIAlertAction>?) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: Style.alert)
        if actions != nil {
            for action in actions! {
                alertVC.addAction(action)
            }
        }
        return alertVC
    }
    
    open class func alert(title: String?, message:String?, okAction: ActionBlock?, cancelAction: ActionBlock?) -> UIAlertController {
        let okAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: okAction)
        return self.alert(title: title, message: message, actions: [okAlertAction], cancelAction: cancelAction)
    }
    
    open class func alert(title: String?, message:String?, actions:Array<UIAlertAction>?, cancelAction: ActionBlock?) -> UIAlertController {
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: cancelAction)
        let alertVC =  self.alert(title: title, message: message, actions: actions)
        alertVC.addAction(cancelAlertAction)
        return alertVC
    }
}
