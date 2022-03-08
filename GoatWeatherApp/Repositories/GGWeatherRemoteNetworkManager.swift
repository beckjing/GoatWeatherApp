//
//  GGWeatherRemoteNetworkManager.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/6.
//

import Foundation
import CoreLocation

public typealias GGWeatherApiCompletion = (_ result: GGWeatherOneCallModel?, _ error: Error?) -> Void

public class GGWeatherRemoteNetworkManager {
    
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    var key: String?
    
    init(key: String) {
        self.key = key
    }
    
    public func fetchWeatherData(_ location: CLLocationCoordinate2D, _ comletion: @escaping (GGWeatherOneCallModel?, Error?) -> Void) {
        var urlComp = URLComponents.init(string: "https://api.openweathermap.org/data/2.5/onecall")!
        urlComp.queryItems = queryParam(coordinates: location)
        var request = URLRequest(url: urlComp.url!)
        request.httpMethod = "GET"
        let task = self.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    comletion(nil, error)
                }
            }
            else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(GGWeatherOneCallModel.self, from: data)
                    DispatchQueue.main.async {
                        comletion(result, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        comletion(nil, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    func queryParam(coordinates: CLLocationCoordinate2D) -> [URLQueryItem] {
        let excludeList: String = "minutely, hourly, alerts"
        let units: String = "metric"
        return [URLQueryItem(name: "appid", value: self.key),
                URLQueryItem(name: "exclude", value: excludeList),
                URLQueryItem(name: "lat", value: String(coordinates.latitude)),
                URLQueryItem(name: "lon", value: String(coordinates.longitude)),
                URLQueryItem(name: "units", value: units)]
    }
    
}
