//
//  GGLocationManager.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/6.
//

import Foundation
import CoreLocation

typealias AuthorizationCompletion = (_ success: Bool) -> Void
typealias LocationUpdatedBlock = (_ location: CLLocation) -> Void

public class GGLocationManager: NSObject {
    
    static let shared = GGLocationManager()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    private lazy var geoCoder: CLGeocoder = {
        let geoCoder = CLGeocoder()
        return geoCoder
    }()
    
    lazy private var completions: Array<AuthorizationCompletion> = {
        let completions = Array<AuthorizationCompletion>()
        return completions
    }()
    
    lazy private var updates: Array<LocationUpdatedBlock> = {
        let updates = Array<LocationUpdatedBlock>()
        return updates
    }()
    
    var lastLocation: CLLocation? = UserDefaults.standard.location(forKey: "lastLocation")
    var lastPlacemark: CLPlacemark?
    
    func shouldRequestAuthorization() -> Bool {
        return self.authorizationStatus() == .notDetermined
    }
    
    func hasAuthorization() -> Bool {
        let authorizationStatus = self.authorizationStatus()
        return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    private func authorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14, *) {
            return self.locationManager.authorizationStatus
        }
        else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    func requestLocation(_ updateBlock: LocationUpdatedBlock?) {
        self.locationManager.requestLocation()
        if updateBlock != nil {
            objc_sync_enter(self)
            self.updates.append(updateBlock!)
            objc_sync_exit(self)
        }
    }
    
    func requestAuthorization(_ completion: AuthorizationCompletion?) {
        let authStatus = self.authorizationStatus()
        switch authStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                if completion != nil {
                    objc_sync_enter(self)
                    self.completions.append(completion!)
                    objc_sync_exit(self)
                }
            case .restricted, .denied:
                completion?(false)
            case .authorizedAlways, .authorizedWhenInUse:
                completion?(true)
            @unknown default:
                assert(true, "Unknown authorization status")
        }
    }
    
    func reverseLocation(_ location: CLLocation, _ competion: CLGeocodeCompletionHandler?) {
        self.geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            competion?(placemarks, error)
        }
    }
}

extension GGLocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            objc_sync_enter(self)
            self.lastLocation = locations.last!
            UserDefaults.standard.setLocation(self.lastLocation!, forKey: "lastLocation")
            for update in updates {
                update(locations.last!)
            }
            self.updates.removeAll()
            manager.stopUpdatingLocation()
            objc_sync_exit(self)
            self.reverseLocation(self.lastLocation!) { [weak self] placemarks, error in
                self?.lastPlacemark = placemarks?.last
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: should implement this method to avoid crash
        print(error)
    }
    
    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        notifyAuthorizationStatusChange(status: authorizationStatus)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        notifyAuthorizationStatusChange(status: status)
    }
    
    func notifyAuthorizationStatusChange(status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined, .restricted, .denied:
                objc_sync_enter(self)
                if completions.isEmpty == false {
                    for completion in completions {
                        completion(false)
                    }
                }
                objc_sync_exit(self)
            case .authorizedAlways, .authorizedWhenInUse:
                objc_sync_enter(self)
                if completions.isEmpty == false {
                    for completion in completions {
                        completion(true)
                    }
                }
                objc_sync_exit(self)
            @unknown default:
                assert(true, "Unknown authorization status")
        }
    }
    
}

extension UserDefaults {
    
    open func setLocation(_ location: CLLocation, forKey key: String) {
        self.set(["lat": location.coordinate.latitude, "lon": location.coordinate.longitude], forKey:key)
    }
    
    open func location(forKey key: String) -> CLLocation? {
        let result = self.object(forKey: key) as? Dictionary<String, Double>
        if result != nil {
            return CLLocation.init(latitude: result!["lat"]!, longitude: result!["lon"]!)
        }
        return nil
    }
    
}
