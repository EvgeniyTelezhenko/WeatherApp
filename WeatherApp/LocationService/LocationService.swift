//
//  LocationService.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 12.06.2021.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
   func fetchWeatherBy(location: CLLocation)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private var currentCoordinate: CLLocationCoordinate2D?
    private var locationManager: CLLocationManager?
    weak var delegate: LocationServiceDelegate?
    
    override init(){
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestLocation()
    }
    
    func setCoordinate(coordinate: CLLocationCoordinate2D){
        currentCoordinate = coordinate
    }
    
    func fetchCoordinates() -> CLLocationCoordinate2D {
        if let currentCoordinate = currentCoordinate {
            return currentCoordinate
        }
        return CLLocationCoordinate2D()
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
    func fetchСityCoordinates(_ cityName: String) {
        getCoordinateFrom(address: cityName){ coordinate , error in
            guard let coordinate = coordinate, error == nil else { return }
            DispatchQueue.main.async {
                self.setCoordinate(coordinate: coordinate)
            }
        }
    }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            if let location = locations.last {
                delegate?.fetchWeatherBy(location: location)
            }
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }

    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}

