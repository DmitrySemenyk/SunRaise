//
//  PropertyWeatherView.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 22/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

class PropertyWeatherView: UIView {

    @IBOutlet weak var timeWhenSunriseLabel: UILabel!
    @IBOutlet weak var rainProbabilityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var precipitationValueLabel: UILabel!
    @IBOutlet weak var distanceVisibilityLabel: UILabel!
    class func instantiateFromNib() -> PropertyWeatherView {
        guard let nib = UINib(
        nibName: "PropertyWeatherView",
        bundle: Bundle.main).instantiate(
            withOwner: nil,
            options: nil).first as? PropertyWeatherView else {return PropertyWeatherView()}
        return nib
    }
    func set(_ sunraise: String,
             rainProbability: String,
             _ windSpeed: String,
             _ precipValue: String,
             distanceValue: String) {
        timeWhenSunriseLabel.text = sunraise
        rainProbabilityLabel.text = rainProbability
        windSpeedLabel.text = windSpeed
        precipitationValueLabel.text = precipValue
        distanceVisibilityLabel.text = distanceValue
    }
}
