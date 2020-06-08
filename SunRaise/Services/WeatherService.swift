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
    static let sharedInstance = WeatherService()
    func getDailyJSON(lat: String, lon: String, completion: LoadSuccesfullWeather?) {
        //swiftlint:disable all
         let weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=22b9e2940a9d8aa928e03d767d262547&units=metric&lat=\(lat)&lon=\(lon)"
        //swiftlint:enable all
        if let url = URL(string: weatherURL) {
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
        //swiftlint:disable all
        let weatherURL: String = "https://api.openweathermap.org/data/2.5/onecall?appid=22b9e2940a9d8aa928e03d767d262547&units=metric&lat=\(lat)&lon=\(lon)"
        //swiftlint:enable all
        if let url = URL(string: weatherURL) {
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
