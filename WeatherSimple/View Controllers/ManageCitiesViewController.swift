//
//  ManageCitiesViewController1.swift
//  WeatherSimple
//
//  Created by Alexander on 22.10.2020.
//

import UIKit
import CoreData

class ManageCitiesViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let networkWeatherManager = NetworkWeatherManager()
    var fetchResultsController: NSFetchedResultsController<CityWeather>!
    
    var cities: [CityWeather] = []
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func deleteObject(_ cityWeather: CityWeather) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*let fetchRequest: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        
        do {
            //cities = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ManageView загрузилось")
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
    }

    // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        cities = controller.fetchedObjects as! [CityWeather]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityTableViewCell
        
        cell.cityName?.text = cities[indexPath.row].cityName
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.temperature?.text = String(format: "%.0f°", cities[indexPath.row].temperature)
            case 1:
                cell.temperature?.text = String(format: "%.0f°", (cities[indexPath.row].temperature*9/5 + 32))
            default:
                cell.temperature?.text = String(format: "%.0f°C", cities[indexPath.row].temperature)
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
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
