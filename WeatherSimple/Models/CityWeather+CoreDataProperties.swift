//
//  CityWeather+CoreDataProperties.swift
//  WeatherSimple
//
//  Created by Alexander on 30.10.2020.
//
//

import Foundation
import CoreData


extension CityWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeather> {
        return NSFetchRequest<CityWeather>(entityName: "CityWeather")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var temperature: Double
    @NSManaged public var weatherDescription: String?

    /*convenience init?(cityWeatherData: CityWeatherData) {
        self.init()
        cityName = cityWeatherData.name
        temperature = cityWeatherData.main.temp
        weatherDescription = cityWeatherData.weather.first!.description
    }*/
}

extension CityWeather : Identifiable {

}
