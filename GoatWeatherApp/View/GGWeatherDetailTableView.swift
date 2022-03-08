//
//  GGWeatherDetailTableView.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import UIKit

class GGWeatherDetailTableView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: String(describing: GGWeatherDetailCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: GGWeatherDetailCell.self))
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let dailyModel: GGWeatherOneCallDailyModel
    
    init(frame: CGRect = .zero, _ dailyModel: GGWeatherOneCallDailyModel) {
        self.dailyModel = dailyModel
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemBackground
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GGWeatherDetailTableView: UITableViewDelegate {
    
}

extension GGWeatherDetailTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayCell: GGWeatherDetailCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GGWeatherDetailCell.self), for: indexPath) as! GGWeatherDetailCell
        let date = Date.init(timeIntervalSince1970: TimeInterval.init(dailyModel.dt!))
        dayCell.dayLabel.text = Date.weekday(timeZone: nil, date: date)
        dayCell.weatherImage.sd_setImage(with: URL(string: dailyModel.weather!.first!.iconUrl()), completed: nil)
        dayCell.descLabel.text = dailyModel.weather!.first!.description
        dayCell.tempRangeLabel.text = "\(String(format: "%.1f", dailyModel.temp!.min!))º~\(String(format: "%.1f", dailyModel.temp!.max!))º"
        return dayCell
    }
    
    
}
