//
//  GGWeatherTableView.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import UIKit
import SnapKit
import Combine

class GGWeatherTableView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        tableView.register(UINib.init(nibName: String(describing: GGWeatherHeaderCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: GGWeatherHeaderCell.self))
        tableView.register(UINib.init(nibName: String(describing: GGWeatherDayCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: GGWeatherDayCell.self))
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        return tableView
    }()
    
    let viewModel: GGWeatherTableViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init(frame: CGRect = .zero, viewModel: GGWeatherTableViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        viewModel
            .$onCallModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    @objc func refreshTableView() {
        self.tableView.refreshControl?.endRefreshing()
        self.viewModel.refreshWeather()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GGWeatherTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        let sectionType = GGWeatherSectionType.init(rawValue: indexPath.section)!
        switch sectionType {
            case .header:
                break
            case .day:
                if let dayModel = viewModel.onCallModel?.daily?[indexPath.row] {
                    viewModel.selectDay(dayModel)
                }
            case .all:
                break
        }
        
    }
    
}

extension GGWeatherTableView: UITableViewDataSource {
    
    enum GGWeatherSectionType: Int {
        case header = 0
        case day
        case all
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return GGWeatherSectionType.all.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = GGWeatherSectionType.init(rawValue: section)!
        switch sectionType {
            case .header:
                if self.viewModel.onCallModel?.current != nil {
                    return 1
                }
                return 0
            case .day:
                if let daily = self.viewModel.onCallModel?.daily {
                    return daily.count
                }
                return 0
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = GGWeatherSectionType.init(rawValue: indexPath.section)!
        switch sectionType {
            case .header:
                let headerCell: GGWeatherHeaderCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GGWeatherHeaderCell.self), for: indexPath) as! GGWeatherHeaderCell
                if let onCallModel = viewModel.onCallModel {
                    if let city = onCallModel.city {
                        headerCell.cityLabel.text = city
                    }
                    if let currentModel = onCallModel.current {
                        headerCell.tempLabel.text = String(format: "%.1f", currentModel.temp!) + "º"
                        headerCell.weatherInfoLabel.text = currentModel.weather!.first?.description
                    }
                }
                return headerCell
            case .day:
                let dayCell: GGWeatherDayCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GGWeatherDayCell.self), for: indexPath) as! GGWeatherDayCell
                if let dayModel = self.viewModel.onCallModel?.daily?[indexPath.row] {
                    dayCell.tempRangeLabel.text = "\(String(format: "%.1f", dayModel.temp!.min!))º~\(String(format: "%.1f", dayModel.temp!.max!))º"
                    dayCell.weatherImage.sd_setImage(with: URL(string: dayModel.weather!.first!.iconUrl()), completed: nil)
                    let date = Date.init(timeIntervalSince1970: TimeInterval.init(dayModel.dt!))
                    dayCell.dayLabel.text = viewModel.weekday(timeZone: viewModel.onCallModel?.timezone, date: date)
                    dayCell.dateLabel.text = viewModel.dateString(timeZone: viewModel.onCallModel?.timezone, date: date)
                }
                return dayCell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.classForCoder()), for: indexPath)
                return cell
        }
    }
    
    
}
