//
//  CityWeatherViewModelProtocol.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 24.06.2021.
//

import Foundation

protocol CityWeatherViewModelProtocol: HourViewDelegate {
    var onChangeSegmentValue: (() -> Void)? {get set}
    var onAnimateArcView: (() -> Void)? {get set}
    var onSetCurrentWeatherModel: (() -> Void)? {get set}
    var onCheckHourSegment:(() -> Void)? {get set}
    var onSetupInitialState: (() -> Void)? {get set}
    var onSetImages: (() -> Void)? {get set}
    var onSetupCityView: ((String?) -> Void)? {get set}
    var onSetupArcView: (() -> Void)? {get set}
    var locationService: LocationService {get}
    var networkService: CurrentWeatherNetworkService {get}
    var event: Event? {get set}
    var currentWeatherModel: WeatherModel? {get set}
    var weatherModel: WeatherModel? {get set}
    init(networkService: CurrentWeatherNetworkService, locationService: LocationService )
    func updateState()
    func fetchDataWithRaw(_ indexPath: IndexPath) -> (String, String)
    func convertDateToDayPercent() -> (sunrise: Float, current: Float,sunset: Float)
}

extension CityWeatherViewModelProtocol {
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
    
    func fetchGIFURL(weatherModel: WeatherModel) -> String{
        var result = ""
        switch weatherModel.backgroundImage {
        case 200...299:
            result =  "https://media.giphy.com/media/3oEjHB1EKuujDjYFWw/giphy.gif"
        case 300...399:
            result = "https://media.giphy.com/media/Mgq7EMQUrhcvC/giphy.gif"
        case 500...599:
            result = "https://media.giphy.com/media/P0ar8pIucRwje/giphy.gif"
        case 600...699:
            result = "https://media.giphy.com/media/gvKru3mU4wLFm/giphy.gif"
        case 700...799:
            result = "https://media.giphy.com/media/11uphU5Zfgk1vW/giphy.gif"
        case 800:
            if weatherModel.icon == "01d"{
                result = "https://media.giphy.com/media/XAe9aDBIv3arS/giphy.gif"
            } else {
                result = "https://media.giphy.com/media/LoNF8cgrrwYju5DxQL/giphy.gif"
            }
        case 801...804:
            result = "https://media.giphy.com/media/67uxmHhIF3uh6Ph8ew/giphy.gif"
        default:
            result = "https://media1.giphy.com/media/vKz8r5aTUFFJu/giphy.gif?cid=ecf05e47ektzu18ufrna1y5pc45x6qkemcypqy6ti12cnzyn&rid=giphy.gif&ct=g"
        }
        return result
    }
}
