//
//  CityWeatherViewModel+LocationServiceDelegate.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 24.06.2021.
//

import Foundation
import CoreLocation

extension CityWeatherViewModel: LocationServiceDelegate {
    func fetchWeatherBy(location: CLLocation)  {
        networkService.performRequest(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        locationService.getPlace(for: location) { placemark in
            guard let placemark = placemark else { return }
            if let town = placemark.locality {
                self.onSetupCityView?(town)
            }
        }
    }
}

extension CityWeatherViewModel: CurrentWeatherNetworkServiceDelegate {
    func setWeatherModel(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        self.currentWeatherModel = weatherModel
    }
}
