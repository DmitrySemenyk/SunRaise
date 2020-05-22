//
//  Daily.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 22/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation
// swiftlint:disable all
struct Daily: Codable {
    var dt: Date?
    var temp: Temp?
    var weather: [Weather]?
}
// swiftlint:enable all
