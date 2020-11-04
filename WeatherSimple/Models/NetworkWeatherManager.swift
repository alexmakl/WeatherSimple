//
//  NetworkWeatherManager.swift
//  WeatherSimple
//
//  Created by Alexander on 23.10.2020.
//

import Foundation
import CoreData

protocol NetworkWeatherManagerDelegate: class {
    func saveWeather(_: NetworkWeatherManager, with cityWeatherData: CityWeatherData)
    func openErrorAlert()
}

class NetworkWeatherManager {
    
    var delegate: NetworkWeatherManagerDelegate?
    
    enum RequestType {
        case cityName(cityName: String)
        case cityId(cityId: Int)
    }
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
            case .cityName(let cityName):
                urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&lang=ru&units=metric"
            case .cityId(let cityId):
                urlString = "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(apiKey)&lang=ru&units=metric"
        }
        performRequest(withUrlString: urlString)
    }
    
    func performRequest(withUrlString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        print(url)
        let session = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        let mcvc = ManageCitiesViewController()
        delegate = mcvc
        
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                print(String("Data: "))
                print(String(data: data, encoding: .utf8))
                if let cityWeatherData = self?.parseJSON(withData: data) {
                    
                    self?.delegate!.saveWeather(self!, with: cityWeatherData)
                    print(String("Распарсили джейсон"))
                }
            } else {
                self?.delegate?.openErrorAlert()
            }
        }
        dataTask?.resume()
    }
    
    func parseJSON(withData data: Data) -> CityWeatherData? {
        let decoder = JSONDecoder()
        do {
            let cityWeatherData = try decoder.decode(CityWeatherData.self, from: data)
            print(cityWeatherData)
            return cityWeatherData
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        return nil
    }
}
