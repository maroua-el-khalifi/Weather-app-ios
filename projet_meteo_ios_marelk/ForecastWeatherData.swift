//
//  forecastWeather.swift
//  projet_meteo_ios_marelk
//
//  Created by user on 10/02/2023.
//  Copyright © 2023 user. All rights reserved.
//

import Foundation

struct ForecastWeather: Codable {
    let list: [List]
    let city: City
}

struct List: Codable {
    var date: Int
    var mainValue: ForecastWeatherMainValue
    var elements: [WeatherElement]
    var wind: WeatherWind
    

    enum CodingKeys: String, CodingKey {
        case wind
        case mainValue = "main"
        case date = "dt"
        case elements = "weather"
        
       
    }

}



extension List: Identifiable {
    var id: String { "\(date)" }
}

struct ForecastWeatherMainValue: Codable {
    let temp: Double
    var tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
    
}



struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    
}

struct WeatherWind: Codable {
let speed: Double
    }

struct City: Codable {
    let name : String
    let country : String
    let coord : Coord
}



