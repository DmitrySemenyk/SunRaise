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
    var sunrise: Date
    var sunset: Date
    var clouds: Int?

    init?(
        cityName: String,
        mainDiscr: String,
        fullDescription: String,
        tem: Double,
        maxTemp: Double,
        minTemp: Double,
        visibility: Int,
        pressure: Int,
        humidity: Int,
        sunrise: Date,
        sunset: Date,
        clouds: Int
        ) {
        self.cityName = cityName
        self.mainDiscr = mainDiscr
        self.fullDescription = fullDescription
        self.tempreture = Int(tem)
        self.maxTempreture = Int(maxTemp)
        self.minTempreture = Int(minTemp)
        self.visibility = visibility
        self.pressure = pressure
        self.humidity = humidity
        self.sunrise = sunrise
        self.sunset = sunset
        self.clouds = clouds
    }
}

class DailyWeatherData {
    var hourly: [Hourly]?
    var daily: [Daily]?
}
