//
//  GGWeatherMainViewController.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/6.
//

import UIKit
import CoreLocation
import SnapKit
import FLEX
import SDWebImage

class GGWeatherMainViewController: UIViewController {
    
    lazy var viewModel: GGWeatherTableViewModel = {
        let viewModel = GGWeatherTableViewModel()
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        if GGLocationManager.shared.hasAuthorization() {
            self.viewModel.refreshWeather()
        }
    }
    
    override func loadView() {
        view = GGWeatherTableView(viewModel: self.viewModel)
    }
    
    func configNavigationBar() {
        self.title = "Weather"
        let hasAuthorization = GGLocationManager.shared.hasAuthorization()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: hasAuthorization ? "location.fill" : "location"), style: hasAuthorization ? .done : .plain, target: self, action: #selector(requestAuthorization(button:)))
    }
    
    @objc func requestAuthorization(button: UIBarButtonItem) {
        if GGLocationManager.shared.hasAuthorization() == false {
            GGLocationManager.shared.requestAuthorization { [weak self] success in
                self?.configNavigationBar()
                if success {
                    self?.viewModel.refreshWeather()
                }
                else {
                    let alert = UIAlertController.alert(title: "Authorize location failed.", message: "Please go to setting page for location authorization.") { action in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    } cancelAction: { action in
                        
                    }
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    #if DEBUG
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            FLEXManager.shared.showExplorer()
        }
    }
    #endif
}

extension GGWeatherMainViewController: UITableViewDelegate {
    
}


