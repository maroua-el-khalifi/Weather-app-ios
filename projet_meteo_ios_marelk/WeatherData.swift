//
//  Weather.swift
//  projet_meteo_ios_marelk
//
//  Created by user on 02/02/2023.
//  Copyright © 2023 user. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    var main : Main
    let name:String
    let weather: [Weather]
    let sys : Sys
    //let timeZone: Int
    let dt : Int
    let coord: Coord
    let wind : Wind
}
    
    struct Main : Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var humidity: Int
        var pressure : Int
    }
    struct Weather: Codable {
        let description: String
        let id:Int
        let icon:String
    }
    
    struct Sys:Codable {
        let country:String
    }

struct Coord: Codable{
    let lon: Double
    let lat: Double
}

struct Wind: Codable{
    let speed: Double
    
}


