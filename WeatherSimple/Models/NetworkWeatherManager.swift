//
//  NetworkWeatherManager.swift
//  WeatherSimple
//
//  Created by Alexander on 23.10.2020.
//

import Foundation

protocol NetworkWeatherManagerDelegate: class {
    func updateInterface(_: NetworkWeatherManager, with cityWeather: CityWeather)
    func openErrorAlert()
}

class NetworkWeatherManager {
    
    weak var delegate: NetworkWeatherManagerDelegate?
    
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
        
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                print(String("Data: "))
                print(String(data: data, encoding: .utf8))
                if let cityWeather = self?.parseJSON(withData: data) {
                    self?.delegate?.updateInterface(self!, with: cityWeather)
                }
            } else {
                self?.delegate?.openErrorAlert()
            }
        }
        dataTask?.resume()
        
    }
    
    func parseJSON(withData data: Data) -> CityWeather? {
        let decoder = JSONDecoder()
        do {
            let cityWeatherData = try decoder.decode(CityWeatherData.self, from: data)
            print(String("Parsed cityWeatherData: " + cityWeatherData.name))
            guard let cityWeather = CityWeather(cityWeatherData: cityWeatherData) else {
                print(String("cityWeather: nil!!!!!"))
                return nil
            }
            print(String("Parsed cityWeather: " + cityWeather.cityName))
            return cityWeather
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
