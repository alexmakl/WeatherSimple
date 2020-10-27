//
//  AddCityViewController.swift
//  WeatherSimple
//
//  Created by Alexander on 19.10.2020.
//

import UIKit
import CoreData

class AddCityViewController: UIViewController {
    
    var context: NSManagedObjectContext!
    var networkWeatherManager = NetworkWeatherManager()
    var newCityWeather: CityWeather?
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBAction func addCityButton(_ sender: UIButton) {
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //networkWeatherManager.onCompletion = { cityWeather in
        //    print(cityWeather.cityName)
        //}
        // Do any additional setup after loading the view.
    }
    
    func saveNewCity() {
        guard let cityName = cityNameTextField?.text else { return }
        if cityName != "" {
            let newCityName = cityName.split(separator: " ").joined(separator: "$20")
            print(newCityName)
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(cityName: newCityName))
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
