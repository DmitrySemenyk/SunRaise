//
//  Hourly.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 22/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation
// swiftlint:disable all
struct Hourly: Codable {
    var dt: Date?
    var temp: Double?
    var weather: [Weather]
    var rain: Rain?
}
// swiftlint:enable all
