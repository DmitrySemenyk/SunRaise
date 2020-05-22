//
//  Extension+Date.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 14/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation

extension Date {
    var intVal: Int? {
        if let day = Date.coordinate {
             let inteval = Date().timeIntervalSince(day)
             return Int(inteval)
        }
        return nil
    }

    static let coordinate: Date? = {
        let dateFormatCoordinate = DateFormatter()
        dateFormatCoordinate.dateFormat = "hh"
        if let day = dateFormatCoordinate.date(from: "12") {
            return day
        }
        return nil
    }()
}

extension Int {
    var dateVal: Date? {
        // convert Int to Double
        let interval = Double(self)
        if let day = Date.coordinate {
            return  Date(timeInterval: interval, since: day)
        }
        return nil
    }
}
