//
//  dailyForcast.swift
//  projet_meteo_ios_marelk
//
//  Created by user on 13/02/2023.
//  Copyright © 2023 user. All rights reserved.
//

import Foundation


struct DailyWeather : Codable {
    var daily : [daily]
}
struct daily : Codable{
    var dt : Int
    var temp : temp
    var weather : [weather]
}

struct temp : Codable {
    var day : Double
    var min : Double
    var max : Double
}

struct weather : Codable {
    var icon : String
    var description : String
}
