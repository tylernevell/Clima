//
//  ViewController.swift
//  Clima
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        // for constant monitor and reporting of location, use startUpdatingLocatio() property
        locationManager.requestLocation()
        
        // tap into the delegate to set it as the current class; accessed through self property
        // tells textfield to report back keyboard actions to view controller
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
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
            cityLabel.text = city
        }
        
        // clear out input box
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        locationManager.stopUpdatingLocation()
    }
    
    // failure to implement didFailWithError will result in a crash and is a programmer error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

