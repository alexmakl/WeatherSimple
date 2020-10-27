//
//  ManageCitiesViewController1.swift
//  WeatherSimple
//
//  Created by Alexander on 22.10.2020.
//

import UIKit
import CoreData

class ManageCitiesViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var networkWeatherManager = NetworkWeatherManager()
    
    var cities = [CityWeather]()
    //var firstCityWeather = CityWeather(cityWeatherData: CityWeatherData(name: "London", main: Main(temp: 10.0), weather: [Weather(weatherDescription: "Облачно")]))
    //cities.append(firstCityWeather)
    
    //var cities = [CityWeather(cityWeatherData: CityWeatherData(name: "London", main: Main(temp: 10.0), weather: [Weather(description: "Облачно")]))
    //]
    
    func deleteObject(_ city: CityWeather) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWeatherManager.delegate = self
        // ? tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityCell")
        //networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(cityName: "Moscow"))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityTableViewCell
        
        cell.cityName.text = cities[indexPath.row].cityName
        cell.temperature.text = cities[indexPath.row].temperatureString
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //let city = cities[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            // TODO: Удалить объект из кор даты
            self.cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let deleteActionConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        //deleteActionConfig.performsFirstActionWithFullSwipe = true
        return deleteActionConfig
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let addCityVC = segue.source as? AddCityViewController else { return }
        addCityVC.saveNewCity()
        //cities.append(addCityVC.newCityWeather)
        //DispatchQueue.main.async {
        //    self.tableView.reloadData()
        //}
    }
}

extension ManageCitiesViewController: NetworkWeatherManagerDelegate {
    func updateInterface(_: NetworkWeatherManager, with cityWeather: CityWeather) {
        print(String("updateInterface cityWeather.cityName: " + cityWeather.cityName))
        
        guard let entity = NSEntityDescription.entity(forEntityName: "City", in: context) else { return }
        let city = NSManagedObject(entity: entity, insertInto: context) as! City
        city.cityName = cityWeather.cityName
        city.temperature = cityWeather.temperature
        city.weatherDescription = cityWeather.description
        
        cities.append(cityWeather)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func openErrorAlert() {
        let alertController = UIAlertController(title: "Ошибка", message: "Город не найден", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
