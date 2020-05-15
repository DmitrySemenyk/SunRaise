//
//  Extension+Date.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 14/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation

extension Date{
    var intVal: Int?{
        if let d = Date.coordinate{
             let inteval = Date().timeIntervalSince(d)
             return Int(inteval)
        }
        return nil
    }


    // today's time is close to `2020-04-17 05:06:06`

    static let coordinate: Date? = {
        let dateFormatCoordinate = DateFormatter()
        dateFormatCoordinate.dateFormat = "hh"
        if let d = dateFormatCoordinate.date(from: "12") {
            return d
        }
        return nil
    }()
}


extension Int{
    var dateVal: Date?{
        // convert Int to Double
        let interval = Double(self)
        if let d = Date.coordinate{
            return  Date(timeInterval: interval, since: d)
        }
        return nil
    }
}
