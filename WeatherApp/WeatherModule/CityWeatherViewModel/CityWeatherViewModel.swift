//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 09.06.2021.
//

import UIKit
import CoreLocation

class CityWeatherViewModel: CityWeatherViewModelProtocol {
    var onChangeSegmentValue: (() -> Void)?
    var onAnimateArcView: (() -> Void)?
    var onSetCurrentWeatherModel: (() -> Void)?
    
    var onSetImages: (() -> Void)?
    var onCheckHourSegment:(() -> Void)?
    
    var onSetupInitialState: (() -> Void)?
    var onSetupCityView: ((String?) -> Void)?
    var onSetupArcView: (() -> Void)?
    
    var locationService: LocationService
    var networkService: CurrentWeatherNetworkService
    
    var event: Event? {
        didSet {
            updateState()
        }
    }
    
    var currentWeatherModel: WeatherModel? {
        didSet {
            event = .modelLoaded
        }
    }
    
    var weatherModel: WeatherModel? {
        didSet {
            if oldValue?.time != nil {
                event = .modelChanged
            }
        }
    }
    
    private var sunsetTime: String?
    private var sunriseTime: String?
    private var currentTime: String?
    
    required init(networkService: CurrentWeatherNetworkService, locationService: LocationService ){
        self.locationService = locationService
        self.networkService = networkService
    }
    
    func updateState() {
        switch event {
        
        case .initial :
            onSetupInitialState?()
            onCheckHourSegment?()
        case .modelLoaded:
            onSetupCityView?(nil)
            
            setTimes()
            onSetupArcView?()
            
            onSetImages?()
            
            onCheckHourSegment?()
        case .segmentDidChangedValue:
            onCheckHourSegment?()
        case .modelChanged:
            onSetupCityView?(nil)
            
            setTimes()
            onAnimateArcView?()
            onSetImages?()
            
            onCheckHourSegment?()
        default:
            print("default")
        }
    }
    
    private func setTimes(){
        
        guard let weatherModel = weatherModel else { return }
        
        currentTime = convertDateFromUTF(weatherModel.time)
        sunriseTime = convertDateFromUTF(weatherModel.sunriseTime)
        sunsetTime = convertDateFromUTF(weatherModel.sunsetTime)
    }
    
    func selectedItemAt(_ indexPath: IndexPath) {
        guard let currentWeatherModel = currentWeatherModel else { return }
        self.weatherModel = WeatherModel(fromHour: currentWeatherModel.hourly[indexPath.item], oldModel: currentWeatherModel)
        onChangeSegmentValue?()
    }
    
    func convertDateFromUTF(_ dateInUTF: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(dateInUTF)))
    }
    
    func fetchDataWithRaw(_ indexPath: IndexPath) -> (String, String) {
        guard let weatherModel = weatherModel, let sunriseTime = sunriseTime, let sunsetTime = sunsetTime else {
            return ("","")
        }
        
        switch indexPath.row {
        case 0:
            return ("ВОСХОД СОЛНЦА", "\(sunriseTime)")
        case 1:
            return ("ЗАХОД СОЛНЦА", "\(sunsetTime)")
        case 2:
            return ("ВЕТЕР","\(String(describing: weatherModel.windDegree!.rawValue))  \(weatherModel.windSpeed)")
        case 3:
            return ("ОЩУЩАЕТСЯ КАК", "\(weatherModel.feelsLikeTemperature)")
        case 4:
            return ("ДАВЛЕНИЕ","\(weatherModel.pressure)")
        case 5:
            return ("ВЛАЖНОСТЬ", "\(weatherModel.humidity)%")
        case 6:
            return ("УФ-ИНДЕКС","\(weatherModel.uvi)")
        default:
            return ("!","?")
        }
    }
    
    func convertDateToDayPercent() -> (sunrise: Float, current: Float,sunset: Float)  {
        if let weatherModel = weatherModel {
            let current = convertTimeToPercent(current: weatherModel.time)
            let sunrise = convertTimeToPercent(current: weatherModel.sunriseTime)
            let sunset = convertTimeToPercent(current: weatherModel.sunsetTime)
            let result = (sunrise, current, sunset)
            return result
        }
        return (0,0,0)
    }
    
    private func convertTimeToPercent(current currentTime: Int) -> Float {
        let dateFormatter = DateFormatter()
        
        let currentDate = Date(timeIntervalSince1970: TimeInterval(currentTime))
        
        dateFormatter.dateFormat = "HH"
        let hours = Float(dateFormatter.string(from: currentDate))
        dateFormatter.dateFormat = "mm"
        let minutes = Float(dateFormatter.string(from: currentDate))
        
        let dayStart = Float(currentTime) - 3600 * hours! - 60 * minutes!
        let dayEnd = Float(dayStart) + 3600 * 24
        
        let result = ((Float(currentTime) - dayStart) / (dayEnd - dayStart))
        return result
    }
}


