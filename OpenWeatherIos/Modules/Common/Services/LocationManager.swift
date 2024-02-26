//
//  LocationManager.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/07/2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {

    let locationManager = CLLocationManager()

    private var requestLocationCompletion: ((CLPlacemark?) -> Void)?
    var didChangeAuthorizationHandler: ((Bool) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    public func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func requestLocation(completion: ((CLPlacemark?) -> Void)?) {
        requestLocationCompletion = completion
        locationManager.requestLocation()
    }

    public func reverseGeocodeLocation(location: CLLocation, completion: ((CLPlacemark?) -> Void)?) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                completion?(nil)
                return
            }

            completion?(placemark)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            requestLocationCompletion?(nil)
            requestLocationCompletion = nil
            return
        }

        reverseGeocodeLocation(location: location) { [weak self] placemark in
            guard let self = self else { return }

            self.requestLocationCompletion?(placemark)
            self.requestLocationCompletion = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        requestLocationCompletion?(nil)
        requestLocationCompletion = nil
    }

    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            didChangeAuthorizationHandler?(true)
        default:
            didChangeAuthorizationHandler?(false)
        }
    }
}
