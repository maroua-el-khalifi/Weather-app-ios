//
//  WeatherModel.swift
//  projet_meteo_ios_marelk
//
//  Created by user on 09/02/2023.
//  Copyright © 2023 user. All rights reserved.
//

import Foundation
import UIKit

struct WeathetModel {
    
    //currentWeather data
    let conditionId: Int
    let cityName:String
    let temp_min:Double
    let temp_max:Double
    let pressure : Int
    let icon:String
    let humidity:Int
    let temperature: Double
    let description:String
    let country:String
    let wind:Double
    let lat: Double
    let lon: Double
    
    //forecastWeather Data
    let date:Int
    
    var temperatureString:String {
        return String(Int(temperature))
    }
    
    
}
