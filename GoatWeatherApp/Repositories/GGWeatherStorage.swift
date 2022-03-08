//
//  GGWeatherStorage.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/7.
//

import Foundation

let OneCallModelKey = "OneCallModelKey"

public class GGWeatherStorage {
    
    static let shared = GGWeatherStorage()
    
    func cachedOneCallModel() -> GGWeatherOneCallModel? {
        if let jsonData = UserDefaults.standard.object(forKey: OneCallModelKey) {
            let jsonDecoder = JSONDecoder()
            let oneCallModel = try? jsonDecoder.decode(GGWeatherOneCallModel.self, from: jsonData as! Data)
            return oneCallModel
        }
        return nil
    }
    
    func saveOneCallModel(_ model: GGWeatherOneCallModel) {
        let jsonEncoder = JSONEncoder()
        if let oneCallModel = try? jsonEncoder.encode(model) {
            UserDefaults.standard.setValue(oneCallModel, forKey: OneCallModelKey)
        }
    }
    
    
}
