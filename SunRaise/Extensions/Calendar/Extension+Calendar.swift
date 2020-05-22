//
//  Extension+Calendar.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 13/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation

extension Calendar {
    func getDayOfTheWeeak() -> [String] {
        var array: [String] = []
        var index = Calendar.current.component(.weekday, from: Date())
        for _ in 1...9 {
            if index > 6 {
                array.append(Calendar.current.weekdaySymbols[0])
                index = 1
            } else {
                array.append(Calendar.current.weekdaySymbols[index])
                index += 1
            }
        }
        return array
    }
}
