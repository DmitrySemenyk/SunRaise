//
//  WeatherByHoursCollectionViewCell.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 11/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

class WeatherByHoursCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var rainProbabilityLabel: UILabel!
    @IBOutlet weak var tempretureLabel: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
