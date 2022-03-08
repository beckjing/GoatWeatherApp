//
//  GGWeatherNavigation.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import UIKit

public class GGWeatherNavigation {
    
    static func pushDailyDetail(_ dailyModel: GGWeatherOneCallDailyModel) {
        let ddVC = GGWeatherDetailViewController(dailyModel: dailyModel)
        self.pushVC(vc: ddVC)
    }
    
    static func pushVC(vc: UIViewController) {
        if let rootVC = UIWindow.keyWindow()?.rootViewController {
            if rootVC is UINavigationController {
                (rootVC as! UINavigationController).pushViewController(vc, animated: true)
            }
            else {
                rootVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
