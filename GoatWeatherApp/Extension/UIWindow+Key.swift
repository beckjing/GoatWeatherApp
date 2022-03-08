//
//  UIWindow+Key.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import Foundation
import UIKit

extension UIWindow {
    
    class func keyWindow() -> UIWindow? {
        for windowScene in UIApplication.shared.connectedScenes {
            if windowScene.activationState == .foregroundActive {
                for window in (windowScene as! UIWindowScene).windows {
                    if window.isKeyWindow {
                        return window
                    }
                }
            }
        }
        return nil
    }
}
