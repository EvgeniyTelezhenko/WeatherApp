//
//  CurrentWeatherRequestModel.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 13.06.2021.
//

import Foundation

struct WeatherData: Codable {
    var current: Current
    var hourly: [HourlyWeatherData]
}

struct Current: Codable {
    var sunrise: Int
    var sunset: Int
    var dt: Int
    var temp: Double
    var feelsLike: Double
    var pressure: Double
    var humidity: Int
    var uvi: Double
    var clouds: Int
    var windSpeed: Float
    var windDegree: Int
    var weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
        case dt
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case uvi
        case clouds
        case windSpeed = "wind_speed"
        case windDegree = "wind_deg"
        case weather
        }
    
     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
        sunrise = try container.decode(Int.self, forKey: .sunrise)
        sunset = try container.decode(Int.self, forKey: .sunset)
        dt = try container.decode(Int.self, forKey: .dt)
        temp = try container.decode(Double.self, forKey: .temp)
        feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        pressure = try container.decode(Double.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        uvi = try container.decode(Double.self, forKey: .uvi)
        clouds = try container.decode(Int.self, forKey: .clouds)
        windSpeed = try container.decode(Float.self, forKey: .windSpeed)
        windDegree = try container.decode(Int.self, forKey: .windDegree)
        weather = try container.decode([Weather].self, forKey: .weather)
     }
}


struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct HourlyWeatherData: Codable {
    var dt: Int
    var temp: Double
    var feelsLike: Double
    var pressure: Double
    var humidity: Int
    var uvi: Double
    var clouds: Int
    var windSpeed: Float
    var windDegree: Int
    var weather: [Weather]
    
    enum CodingKeys: String, CodingKey {

        case dt
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case uvi
        case clouds
        case windSpeed = "wind_speed"
        case windDegree = "wind_deg"
        case weather

        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       dt = try container.decode(Int.self, forKey: .dt)
       temp = try container.decode(Double.self, forKey: .temp)
       feelsLike = try container.decode(Double.self, forKey: .feelsLike)
       pressure = try container.decode(Double.self, forKey: .pressure)
       humidity = try container.decode(Int.self, forKey: .humidity)
       uvi = try container.decode(Double.self, forKey: .uvi)
       clouds = try container.decode(Int.self, forKey: .clouds)
       windSpeed = try container.decode(Float.self, forKey: .windSpeed)
       windDegree = try container.decode(Int.self, forKey: .windDegree)
       weather = try container.decode([Weather].self, forKey: .weather)
    }
}

