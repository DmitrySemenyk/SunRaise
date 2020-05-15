//
//  WeatherModel.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 12/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    let name: String
    let dt: Date?
    let main: Main
    let weather: [Weather]
    let visibility: Int
    let sys: Sys
    let clouds: Clouds
    
}


struct HourlyAndDailyModel: Codable{
    let hourly: [Hourly]
    let daily: [Daily]
}


struct Hourly: Codable {
    var dt: Date?
    var temp: Double?
    var weather: [Weather]
    var rain: Rain?
}

struct Daily: Codable{
    var dt: Date?
    var temp: Temp?
    var weather: [Weather]?
}


struct Temp: Codable{
    var max: Double?
    var min: Double?
    //var weather: [Weather]?
}

struct Main: Codable {
    let temp: Double
    let temp_max: Double
    let temp_min: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let id: Int
    let main: String
    let icon: String
}

struct Sys: Codable {
    let sunrise: Date
    let sunset: Date
}

struct Clouds: Codable{
    let all: Int
}

struct Rain: Codable{
    let oneHour: Double?
    enum CodingKeys: String, CodingKey {
        case oneHour  = "1h"
    }
}
