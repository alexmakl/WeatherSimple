//
//  PageViewController.swift
//  WeatherSimple
//
//  Created by Alexander on 31.10.2020.
//

import UIKit
import CoreData

class PageViewController: UIPageViewController {
    
    var context: NSManagedObjectContext!
    //var cities = [CityWeather]()
    var cities: [CityWeather] = []
    
    //var cities = [CityWeather(cityWeatherData: CityWeatherData(name: "London", main: Main(temp: 10.0), weather: [Weather(description: "Облачно")]))
    //]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        /*let fetchRequest: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        
        do {
            cities = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        if cities.count > 0 {
            if let firstVC = displayViewController(atIndex: 0) {
                setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
        } else {
            if let firstVC = displayMock() {
                setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
        }*/
    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < cities.count else { return nil }
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        
        contentViewController.name = cities[index].cityName!
        contentViewController.descr = cities[index].weatherDescription!
        contentViewController.temp = String(cities[index].temperature)
        contentViewController.index = index
        
        return contentViewController
    }
    
    func displayMock() -> ContentViewController? {
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        
        contentViewController.name = "Добавьте город"
        contentViewController.descr = ""
        contentViewController.temp = ""
        
        return contentViewController
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
}
