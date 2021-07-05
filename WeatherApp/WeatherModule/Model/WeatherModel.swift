//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 13.06.2021.
//

import SDWebImage

struct WeatherModel {
    let description: String
    let windSpeed: String
    let windDegree: WindDirection?
    let temperature: String
    let feelsLikeTemperature: String
    let pressure: Double
    let time: Int
    let sunriseTime: Int
    let sunsetTime: Int
    let name: String
    let signImage: String
    let backgroundImage: Int
    let uvi: Double
    let humidity: String
    let icon: String
    let hourly: [HourlyWeatherData]
    init(_ weatherData: WeatherData) {
        self.uvi = weatherData.current.uvi
        self.humidity = "\(weatherData.current.humidity)"
        self.description = weatherData.current.weather[0].description
        self.windSpeed = "\(weatherData.current.windSpeed) м/с"
        self.windDegree = WindDirection.init(degrees: weatherData.current.windDegree)
        self.temperature = "\(Int(weatherData.current.temp)) ℃ "
        self.feelsLikeTemperature = "\(Int(weatherData.current.feelsLike)) ℃ "
        self.pressure = weatherData.current.pressure
        self.time = weatherData.current.dt
        self.sunsetTime = weatherData.current.sunset
        self.sunriseTime = weatherData.current.sunrise
        self.hourly = weatherData.hourly
        self.name = weatherData.current.weather[0].main
        self.signImage = "https://openweathermap.org/img/wn/\(weatherData.current.weather[0].icon)@2x.png"
        self.backgroundImage = weatherData.current.weather[0].id
        self.icon = weatherData.current.weather[0].icon
    }
    
    init(fromHour hour: HourlyWeatherData,oldModel model: WeatherModel ) {
        self.uvi = hour.uvi
        self.humidity = "\(hour.humidity)"
        self.description = "\(hour.weather[0].description)"
        self.windSpeed = "\(hour.windSpeed) м/с"
        self.windDegree =  WindDirection.init(degrees: hour.windDegree)
        self.temperature = "\(Int(hour.temp)) ℃ "
        self.feelsLikeTemperature = "\(Int(hour.feelsLike)) ℃ "
        self.pressure = hour.pressure
        self.time = hour.dt
        self.sunsetTime = model.sunsetTime
        self.sunriseTime = model.sunriseTime
        self.hourly = model.hourly
        self.name = hour.weather[0].main
        self.signImage = "https://openweathermap.org/img/wn/\(hour.weather[0].icon)@2x.png"
        self.backgroundImage =  hour.weather[0].id
        self.icon = hour.weather[0].icon
    }
}


