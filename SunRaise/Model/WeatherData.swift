//
//  WeatherData.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 12/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation

class WeatherData {
    // swiftlint:disable all
    var dt: Date?
    // swiftlint:enable all
    var cityName: String?
    var mainDiscr: String?
    var fullDescription: String?
    var tempreture: Int?
    var maxTempreture: Int?
    var minTempreture: Int?
    var visibility: Int?
    var pressure: Int?
    var humidity: Int?
    var sunrise: Date?
    var sunset: Date?
    var clouds: Int?
}

class DailyWeatherData {
    var hourly: [Hourly]?
    var daily: [Daily]?
}
