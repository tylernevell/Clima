//
//  WeatherManager.swift
//  Clima
//
//  Created by Tyler Nevell on 6/1/20.
//

import Foundation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0c4cb6fcdc98765edff5400edc5dec42&units=imperial"
    
    // for user search
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    //for current location
    func fetchWeather(latitude: Double, longitude: Double) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the Session a task
            // let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            // hit enter to turn completionHandler into a closure automatically
            let task = session.dataTask(with: url) { (data, response, error) in
                // check for any errors
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                //
                if let safeData = data {
                    
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                    // value of the data object (JSON) doesn't directly translate into a string, so we need this string function to translate it
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString)
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
            //print(weather.temperatureString)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
