//
//  Weather.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 22/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation
// swiftlint:disable all
struct Weather: Codable {
    let description: String
    let id: Int
    let main: String
    let icon: String
}
// swiftlint:enable all
