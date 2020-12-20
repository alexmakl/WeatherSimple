//
//  ViewController.swift
//  WeatherSimple
//
//  Created by Alexander on 17.10.2020.
//

import UIKit
import CoreData

class ContentViewController: UIViewController, NSFetchedResultsControllerDelegate, UIScrollViewDelegate {
    
    let networkWeatherManager = NetworkWeatherManager()
    var fetchResultsController: NSFetchedResultsController<CityWeather>!
    var context: NSManagedObjectContext!
    var cities: [CityWeather] = []
    var slides: [Slide] = []
    var frame = CGRect.zero
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func manageButtonPressed(_ sender: UIButton) {
    }
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var name = ""
    var descr = ""
    var temp = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ContentView загрузилось")
        networkWeatherManager.delegate = self
        
        let fetchRequest: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "cityName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                cities = fetchResultsController.fetchedObjects!
                print("Count: " + String(cities.count))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .touchUpInside)
        view.bringSubviewToFront(pageControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if cities.count == 0 {
            print("cities.count = 0")
            let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide.cityName.text = "Добавьте город"
            slide.weatherDescription.text = ""
            slide.temperature.text = ""
            slide.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slide)
        }
    }
    
    func createSlides() -> [Slide] {
        for city in cities {
            let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide.cityName.text = city.cityName
            slide.weatherDescription.text = city.weatherDescription
            slide.temperature.text = String(format: "%.0f°C", city.temperature)
            slides.append(slide)
        }
        return slides
    }
    
    func setupSlideScrollView(slides: [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        let page: Int = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(page), y: 0), animated: true)
        //scrollView.scrollRectToVisible(CGRect(x: view.frame.width * CGFloat(page), y: 0, width: view.frame.width, height: view.frame.height), animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupSlideScrollView(slides: slides)
    }
}

extension ContentViewController: NetworkWeatherManagerDelegate {
    
    func saveWeather(_: NetworkWeatherManager, with cityWeatherData: CityWeatherData) {
        print("Сохраняем полученную погоду в CoreData")
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let cityWeather = CityWeather(context: context)
            cityWeather.cityName = cityWeatherData.name
            cityWeather.temperature = cityWeatherData.main.temp
            cityWeather.weatherDescription = cityWeatherData.weather.first!.description
            self.cities.append(cityWeather)
            
            do {
                try context.save()
                print("Сохранение удалось")
            } catch let error as NSError {
                print(error.localizedDescription)
                print("Сохранение НЕ удалось")
            }
        }
    }
    
    func openErrorAlert() {
        let alertController = UIAlertController(title: "Ошибка", message: "Город не найден", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

