//
//  GGWeatherDetailViewController.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import UIKit

class GGWeatherDetailViewController: UIViewController {
    
    let dailyModel: GGWeatherOneCallDailyModel
    
    init(dailyModel: GGWeatherOneCallDailyModel) {
        self.dailyModel = dailyModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    

    override func loadView() {
        view = GGWeatherDetailTableView(self.dailyModel)
    }

}
