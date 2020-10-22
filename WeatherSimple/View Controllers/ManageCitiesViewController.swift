//
//  ManageCitiesViewController1.swift
//  WeatherSimple
//
//  Created by Alexander on 22.10.2020.
//

import UIKit

class ManageCitiesViewController: UITableViewController {

    var cities = [City(cityName: "Москва", temperature: 10, description: "Облачно"),
                  City(cityName: "Нижний Новгород", temperature: 15, description: "Облачно1")
    ]
    /*@IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    


    @IBAction func TemperatureControl(_ sender: UISegmentedControl) {
    }*/
    func deleteObject(_ city: City) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
}
