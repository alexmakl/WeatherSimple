//
//  ViewController.swift
//  WeatherSimple
//
//  Created by Alexander on 17.10.2020.
//

import UIKit
import CoreData

class ContentViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var name = ""
    var descr = ""
    var temp = ""
    var index = 0
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameLabel.text = name
        weatherDescriptionLabel.text = descr
        temperatureLabel.text = temp
    }
}

