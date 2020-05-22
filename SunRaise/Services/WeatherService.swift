//
//  WeatherManager.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 12/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//
import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func getWeather(weather: WeatherData)
    func getDailyWeather(dailyWeather: DailyWeatherData)
}

struct WeatherManager {
    let weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=22b9e2940a9d8aa928e03d767d262547&units=metric"
    let dailyWeather: String = "https://api.openweathermap.org/data/2.5/onecall?appid=22b9e2940a9d8aa928e03d767d262547&units=metric"
    weak var delegate: WeatherManagerDelegate?
    // MARK: - FetchCurrentWeather
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let localizing = NSLocalizedString("backdend_localization", comment: "")
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)&lang=\(localizing)"
        let dailyWeatherURL = "\(dailyWeather)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
        performHourlyDailyRequest(with: dailyWeatherURL)
    }
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    print("Error")
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.getWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherModel.self, from: weatherData)
            let weather = WeatherData(
                cityName: decodedData.name,
                mainDiscr: decodedData.weather[0].main,
                fullDescription: decodedData.weather[0].description,
                tem: decodedData.main.temp,
                maxTemp: decodedData.main.temp_max,
                minTemp: decodedData.main.temp_min,
                visibility: decodedData.visibility,
                pressure: decodedData.main.pressure,
                humidity: decodedData.main.humidity,
                sunrise: decodedData.sys.sunrise,
                sunset: decodedData.sys.sunset,
                clouds: decodedData.clouds.all
            )
            weather?.dt = decodedData.dt
            return weather
        } catch {
            return WeatherData(cityName: "Empty",
                               mainDiscr: "empty",
                               fullDescription: "empty",
                               tem: 0,
                               maxTemp: 0,
                               minTemp: 0,
                               visibility: 0,
                               pressure: 0,
                               humidity: 0,
                               sunrise: Date(),
                               sunset: Date(),
                               clouds: 0)
        }
    }
    // MARK: - FetchDailyAndHourlyweather
    func fetchHourlyDailyWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performHourlyDailyRequest(with: urlString)
    }
    func performHourlyDailyRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    print("Error")
                }
                if let safeData = data {
                    if let dailyWeather = self.parseDailyJSON(safeData) {
                        self.delegate?.getDailyWeather(dailyWeather: dailyWeather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseDailyJSON(_ weatherData: Data) -> DailyWeatherData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(HourlyAndDailyModel.self, from: weatherData)
            let dailyWeather = DailyWeatherData()
            dailyWeather.daily = decodedData.daily
            dailyWeather.hourly = decodedData.hourly
            return dailyWeather
        } catch {
            return DailyWeatherData()
        }
    }
}
