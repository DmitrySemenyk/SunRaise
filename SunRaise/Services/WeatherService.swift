//
//  WeatherManager.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 12/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//
import Foundation

typealias LoadSuccesfullWeather = (Result<WeatherModel, Error>) -> Void
typealias LoadSuccesfullHourly = (Result<HourlyAndDailyModel, Error>) -> Void
typealias LoadError = (HTTPURLResponse) -> Void

struct WeatherService {
    let apiKey = "22b9e2940a9d8aa928e03d767d262547"
    let units = "metric"
    static var sharedInstance = WeatherService()
    func getDailyJSON(lat: String, lon: String, completion: LoadSuccesfullWeather?) {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?")
        var urlQueryItem = [URLQueryItem]()
        let param = [
            "appid": apiKey,
            "units": units,
            "lat": lat,
            "lon": lon
        ]
        for (key, item) in param {
            urlQueryItem.append(URLQueryItem(name: key, value: item))
        }
        urlComponents?.queryItems = urlQueryItem
        if let url = urlComponents?.url {
            print(url.absoluteString)
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let err = error {
                    print("Error")
                    completion?(.failure(err))
                } else {
                    if let data = data {
                        let decoder = JSONDecoder()
                        if let json = try? decoder.decode(WeatherModel.self, from: data) {
                            print("Data")
                            completion?(.success(json))
                        }
                    }
                }
            }.resume()
        }
    }
    func getHourlyJSON(lat: String, lon: String, completion: LoadSuccesfullHourly?) {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/onecall?")
        var urlQueryItem = [URLQueryItem]()
        let param = [
            "appid": apiKey,
            "units": units,
            "lat": lat,
            "lon": lon
        ]
        for (key, item) in param {
            urlQueryItem.append(URLQueryItem(name: key, value: item))
        }
        urlComponents?.queryItems = urlQueryItem
        if let url = urlComponents?.url {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion?(.failure(error))
                } else {
                    if let data = data {
                        let decoder = JSONDecoder()
                        if let json = try? decoder.decode(HourlyAndDailyModel.self, from: data) {
                            completion?(.success(json))
                        }
                    }
                }
            }.resume()
        }
    }
}
