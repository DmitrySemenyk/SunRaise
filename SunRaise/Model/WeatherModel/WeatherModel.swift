//
//  WeatherModel.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 12/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

// swiftlint:disable all
import Foundation

struct WeatherModel: Codable {
    let name: String
    let dt: Date? //
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
// swiftlint:enable all
