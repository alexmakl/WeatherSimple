//
//  CityData.swift
//  WeatherSimple
//
//  Created by Alexander on 23.10.2020.
//

import Foundation

struct CityWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
}

// MARK: - Weather
struct Weather: Codable {
    //let id: Int
    let description: String
}
