//
//  FullDescriptionWeatherView.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 22/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

class FullDescriptionWeatherView: UIView {

    @IBOutlet weak var fullDescriptionWeatherLabel: UILabel!
    class func instantiateFromNib() -> FullDescriptionWeatherView {
        guard let nib = UINib(
            nibName: "FullDescriptionWeatherView",
            bundle: Bundle.main).instantiate(
                withOwner: nil,
                options: nil).first as? FullDescriptionWeatherView else {return FullDescriptionWeatherView()}
        return nib
    }
    func set(_ fullDescription: String) {
        fullDescriptionWeatherLabel.text = fullDescription
    }

}
