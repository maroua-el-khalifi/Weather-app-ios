//
//  WeatherManager.swift
//  projet_meteo_ios_marelk
//
//  Created by user on 09/02/2023.
//  Copyright © 2023 user. All rights reserved.
//

import Foundation

    protocol WeatherManagerDelegate {
        
        func didUpdateWeather (_ weatherdata: WeatherManager, weather: WeathetModel)
        func didUpdateWeather2 (_ weatherdata: WeatherManager, weather: [WeathetModel], i:Int)
        func didUpdateWeather3 (_ weatherdata: WeatherManager, weather: [DailyModel], i : Int)
        func didUpdateCoords (_ weatherdata: WeatherManager, weather: WeathetModel, i: Int)
        
        func didFailWithError(error: Error)
    }

class WeatherManager {
    let baseUrl="https://api.openweathermap.org/data/2.5"
    var delegate: WeatherManagerDelegate?
    
    func fetchCurrentWeather(cityName: String){
        let suffixUrl = "weather"
        let urlString = "\(baseUrl)/\(suffixUrl)?id=524901&appid=2edc4d91f611d8b5a3e3ae8200fcc968&units=metric&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    // key = e6563be33e3747930c890003ba34825f
    func fetchCurrentWeatherCoord(cityName: String , i : Int) {
        let suffixUrl = "weather"
        let urlString = "\(baseUrl)/\(suffixUrl)?id=524901&appid=2edc4d91f611d8b5a3e3ae8200fcc968&units=metric&q=\(cityName)"
        
             let url = URL(string: urlString)
             let session = URLSession(configuration: .default)
             let task = session.dataTask(with: url!) { data,response, error in
                 if  error != nil {
                     self.delegate?.didFailWithError(error: error!)
                 }
                 if let data = data {
                     if let weather = self.parseJson(data){
                        self.delegate?.didUpdateCoords(self, weather: weather, i: i)
                        
                    }
                }
        }
        task.resume()
    }
    
    func fetchForecastWeather(cityName: String,index : Int){
        let suffixUrl = "forecast"
        let urlString = "\(baseUrl)/\(suffixUrl)?id=524901&appid=e6563be33e3747930c890003ba34825f&units=metric&q=\(cityName)"
       // print (urlString)
        performRequest2(with: urlString, index: index )
    }
    
    func fetchDailyWeather(lon : Double , lat : Double , i : Int){
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&appid=f4bc1306c8c0bda6307d0dc8941437a4&units=metric&exclude=current,minutely,hourly"
        print(urlString)
        performRequest3(with: urlString, i: i)
    }
    
    func performRequest(with url:String){ //current weather
        guard let url = URL(string: url) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data,response, error in
            if  error != nil {
                self.delegate?.didFailWithError(error: error!)
            }
            if let data = data {
                if let weather = self.parseJson(data){
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        task.resume()
        
    }
    
    func performRequestCoords(with url:String , i :Int ){ //to get coords from current weather
    guard let url = URL(string: url) else {return}
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data,response, error in
        if  error != nil {
            self.delegate?.didFailWithError(error: error!)
        }
        if let data = data {
            if let weather = self.parseJson(data){
                self.delegate?.didUpdateCoords(self, weather: weather, i: i)
            }
        }
    }
    task.resume()
    }
    
    func performRequest2(with url:String, index:Int){ //hourly weather
        guard let url = URL(string: url) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data,response, error in
            if  error != nil {
                self.delegate?.didFailWithError(error: error!)
            }
            if let data = data {
                if let weather = self.parseJson2(data){
                    self.delegate?.didUpdateWeather2(self, weather: weather, i: index)
                }
            }
        }
        task.resume()
    }
    func performRequest3(with url:String, i :Int){ //daily weather
        guard let url = URL(string: url) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data,response, error in
            if  error != nil {
                self.delegate?.didFailWithError(error: error!)
            }
            if let data = data {
                if let weather = self.parseJson3(data){
                    self.delegate?.didUpdateWeather3(self, weather: weather, i: i)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    func parseJson(_ weatherData: Data)->WeathetModel?{ //current weather
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)

            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            let icon = decodeData.weather[0].icon
            let descr = decodeData.weather[0].description
            //let timezone = decodeData.timeZone
            let tempMax = decodeData.main.temp_max
            let tempMin = decodeData.main.temp_min
            let humidity = decodeData.main.humidity
            let pressure = decodeData.main.pressure
            let windSpeed = decodeData.wind.speed
            let country = decodeData.sys.country
            let lon = decodeData.coord.lon
            let lat = decodeData.coord.lat
            let date = decodeData.dt
            
            let weather = WeathetModel(conditionId: id, cityName: name, temp_min: tempMin,temp_max: tempMax, pressure: pressure,icon: icon, humidity: humidity, temperature: temp, description: descr, country: country, wind: windSpeed, lat: lat, lon: lon, date: date)
            return weather
            
          
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    func parseJson2(_ weatherData: Data)->[WeathetModel]?{ //hourly weather
        var weatherTab = [WeathetModel]()
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(ForecastWeather.self, from: weatherData)
            for i in 0..<decodeData.list.count{
            let id = decodeData.list[i].elements[0].id
            let temp = decodeData.list[i].mainValue.temp
            let cityName = decodeData.city.name
            let icon = decodeData.list[i].elements[0].icon
            let descr = decodeData.list[i].elements[0].weatherDescription
            let country = decodeData.city.country
            let tempMax = decodeData.list[i].mainValue.tempMax
            let tempMin = decodeData.list[i].mainValue.tempMin
            let humidity = decodeData.list[i].mainValue.humidity
            let pressure = decodeData.list[i].mainValue.pressure
            let windSpeed = decodeData.list[i].wind.speed
            let date = decodeData.list[i].date
            let lat = decodeData.city.coord.lat
            let lon = decodeData.city.coord.lon
                
            
                let weather = WeathetModel(conditionId: id, cityName: cityName, temp_min: tempMin,temp_max: tempMax, pressure: pressure,icon: icon, humidity: humidity, temperature: temp, description: descr, country: country, wind: windSpeed, lat: lat, lon: lon, date: date)
                weatherTab.append(weather)
            }
           
            return weatherTab
            
          
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    func parseJson3(_ weatherData: Data)->[DailyModel]?{ //daily forecast
        var weatherTab = [DailyModel]()
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(DailyWeather.self, from: weatherData)
            for i in 0..<decodeData.daily.count{
                let temp = decodeData.daily[i].temp.day
                let icon = decodeData.daily[i].weather[0].icon
                //let descr = decodeData.daily[i].weather[0].description
                //let tempMax = decodeData.daily[i].temp.max
                //let tempMin = decodeData.daily[i].temp.min
                let date = decodeData.daily[i].dt
               
                let weather = DailyModel(icon: icon, temperature: temp, date: date)
                    weatherTab.append(weather)
            }
           
            return weatherTab
            
          
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
   
}
