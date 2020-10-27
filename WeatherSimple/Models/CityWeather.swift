//
//  CurrentWeather.swift
//  WeatherSimple
//
//  Created by Alexander on 19.10.2020.
//

import Foundation

struct CityWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f°", temperature)
    }
    
    let description: String
    
    init?(cityWeatherData: CityWeatherData) {
        cityName = cityWeatherData.name
        temperature = cityWeatherData.main.temp
        description = cityWeatherData.weather.first!.description
    }
}
