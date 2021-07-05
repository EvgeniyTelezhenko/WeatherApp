//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 12.06.2021.
//

import Foundation
import CoreLocation
import SDWebImage

protocol CurrentWeatherNetworkServiceDelegate: class {
    func setWeatherModel(weatherModel: WeatherModel)
}
class CurrentWeatherNetworkService: NSObject {
    weak var delegate: CurrentWeatherNetworkServiceDelegate?

    let urlString = "https://api.openweathermap.org/data/2.5/onecall?"
    let choosenLanguage: RequestLanguages = .russian
    let choosenUnits: Units = .metric
    
    func performRequest(lat: CLLocationDegrees, lon: CLLocationDegrees)  {
        let finalURL = makeURL(lat: lat, lon: lon)
        if let url = URL(string: finalURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("network service = \(error!)")
                    return
                }
                
                if let data = data {
                    let result = self.parseData(weatherData: data)
                    
                    if let result = result {
                        self.delegate?.setWeatherModel(weatherModel: result)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func makeURL(lat: CLLocationDegrees , lon: CLLocationDegrees) -> String {
        return urlString + "lat=\(lat)" + "&lon=\(lon)" + "&exclude=daily,alerts" + "&appid=1ebfebf9449b1ccfed43421cf76be575" + "&lang=\(choosenLanguage.rawValue)" + "&units=\(choosenUnits.rawValue)"
    }
    
    private func parseData(weatherData: Data) -> WeatherModel? {
        do {
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            return WeatherModel(decodedData)
        } catch {
            print(error)
        }
        return nil
    }
}


