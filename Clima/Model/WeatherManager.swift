//
//  WeatherManager.swift
//  Clima
//
//  Created by Tyler Nevell on 6/1/20.
//

import Foundation

struct WeatherManager {
    
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather?appid=0c4cb6fcdc98765edff5400edc5dec42&units=imperial"
    
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
        
    }
    
    func performRequest(urlString: String) {
        //1. Create a URL
        //2. Create a URLSession
        //3. Give the Session a task
        //4. Start the task
    }
}
