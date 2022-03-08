//
//  GGWeatherTableViewModel.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import CoreLocation

public class GGWeatherTableViewModel {
    
    @Published public private(set) var onCallModel = GGWeatherStorage.shared.cachedOneCallModel()
    
    lazy var networkManager: GGWeatherRemoteNetworkManager = {
        let networkManager = GGWeatherRemoteNetworkManager(key: "162d70b15b74d208aed831c3c4334286")
        return networkManager
    }()
    
    @objc func refreshWeather() {
        GGLocationManager.shared.requestLocation { [weak self] location in
            self?.requestWeatherData(location: location)
        }
    }
    
    func weekday(timeZone: String?, date: Date) -> String {
        var calendar = Calendar.init(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        if let timeZone = timeZone {
            if let tz = TimeZone.init(identifier: timeZone) {
                calendar.timeZone = tz
                dateFormatter.timeZone = tz
            }
        }
        if calendar.isDateInToday(date) {
            return "Today"
        }
        return dateFormatter.string(from: date)
    }
    
    func dateString(timeZone: String?, date: Date) -> String {
        let dateFormatter = DateFormatter()
        if let timeZone = timeZone {
            if let tz = TimeZone.init(identifier: timeZone) {
                dateFormatter.timeZone = tz
            }
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    private func requestWeatherData(location: CLLocation) {
        self.networkManager.fetchWeatherData(location.coordinate) { [weak self] result, error in
            if result != nil {
                self?.onCallModel = result
                GGWeatherStorage.shared.saveOneCallModel((self?.onCallModel!)!)
                self?.requestCity(location: location)
            }
            else if error != nil {
                print(error!)
            }
        }
    }
    
    private func requestCity(location: CLLocation) {
        GGLocationManager.shared.reverseLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.last {
                self?.onCallModel!.city = placemark.name
                GGWeatherStorage.shared.saveOneCallModel((self?.onCallModel!)!)
            }
        }
    }
    
    func selectDay(_ day: GGWeatherOneCallDailyModel) {
        
    }
}
