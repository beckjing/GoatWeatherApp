//
//  GGWeatherOneCallModel.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/6.
//

import UIKit


public struct GGWeatherOneCallModel: Codable {
    let lat: Double?
    let lon: Double?
    let timezone: String?
    let timezone_offset: Int?
    let current: GGWeatherOneCallCurrentModel?
    let daily: [GGWeatherOneCallDailyModel]?
    var city: String?
}

struct GGWeatherOneCallCurrentModel: Codable {
    
    let temp: Double?
    let weather: [GGWeatherOneCallWeatherModel]?

    
}

public struct GGWeatherOneCallDailyModel: Codable {
    
    let dt: Int?
    let temp: GGWeatherOneCallTempModel?
    let weather: [GGWeatherOneCallWeatherModel]?
//    {
//        "dt": 1618308000,
//        "sunrise": 1618282134,
//        "sunset": 1618333901,
//        "moonrise": 1618284960,
//        "moonset": 1618339740,
//        "moon_phase": 0.04,
//        "temp": {
//            "day": 279.79,
//            "min": 275.09,
//            "max": 284.07,
//            "night": 275.09,
//            "eve": 279.21,
//            "morn": 278.49
//        },
//        "feels_like": {
//            "day": 277.59,
//            "night": 276.27,
//            "eve": 276.49,
//            "morn": 276.27
//        },
//        "pressure": 1020,
//        "humidity": 81,
//        "dew_point": 276.77,
//        "wind_speed": 3.06,
//        "wind_deg": 294,
//        "weather": [
//            {
//                "id": 500,
//                "main": "Rain",
//                "description": "light rain",
//                "icon": "10d"
//            }
//        ],
//        "clouds": 56,
//        "pop": 0.2,
//        "rain": 0.62,
//        "uvi": 1.93
//    }
    
}

struct GGWeatherOneCallWeatherModel: Codable {
    
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
    
    func iconUrl() -> String {
        if icon != nil {
            let iconUrl = "https://openweathermap.org/img/wn/\(icon!)@2x.png"
            return iconUrl
        }
        return ""
    }
}

struct GGWeatherOneCallTempModel: Codable {
    let day: Double?
    let min: Double?
    let max: Double?
//    {
//        "day": 279.79,
//        "min": 275.09,
//        "max": 284.07,
//        "night": 275.09,
//        "eve": 279.21,
//        "morn": 278.49
//    }
}
