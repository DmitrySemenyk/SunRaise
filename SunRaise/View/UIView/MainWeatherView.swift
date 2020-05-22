//
//  MainWeatherView.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 22/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

class MainWeatherView: UIView {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDiscriptionLabel: UILabel!
    @IBOutlet weak var currentWeatherTempretureLabel: UILabel!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var curentWeakDayLabel: UILabel!
    @IBOutlet weak var stateOfTheDayLabel: UILabel!
    @IBOutlet weak var nightTempretureLabel: UILabel!
    @IBOutlet weak var dayTempretureLabel: UILabel!
    class func instantiateFromNib() -> MainWeatherView {
        guard let nib = UINib(
            nibName: "MainWeatherView",
            bundle: Bundle.main).instantiate(
                withOwner: nil,
                options: nil).first as? MainWeatherView else {return MainWeatherView()}
        return nib
    }
    func set(_ city: String,
             _ weatherDiscription: String,
             _ currentWeather: String,
             _ nightTempreture: String,
             _ dayTempreture: String) {
        curentWeakDayLabel.text =
            Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        cityNameLabel.text = city
        weatherDiscriptionLabel.text = weatherDiscription
        currentWeatherTempretureLabel.text = currentWeather
        nightTempretureLabel.text = nightTempreture
        dayTempretureLabel.text = dayTempreture
    }

}
