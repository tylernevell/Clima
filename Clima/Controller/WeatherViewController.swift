//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap into the delegate to set it as the current class; accessed through self property
        // tells textfield to report back keyboard actions to view controller
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    // asks the delegate if the textfield should process the pressing of the return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // allows user to escape keyboard by checking if they've inputed something
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please type something."
            return false
        }
    }
    
    // triggered whenever searchTextField.endEditing is called
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Use searchTextField.text to find weather for city
        // if user enters valid string, pass the user input along to the WeatherManager class through cityName parameter
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        // clear out input box
        searchTextField.text = ""
    }
    
}

