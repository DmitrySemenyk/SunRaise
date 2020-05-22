//
//  Extension+UIView.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 13/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public static let defaultFadingAnimationDuration: TimeInterval = 1.0
    func addBottomLine(color: UIColor, height: CGFloat) {
        let bottomView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: height))
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.autoresizingMask = .flexibleWidth
        bottomView.backgroundColor = color
        self.addSubview(bottomView)
    }
    func animate(isHidden: Bool,
                 duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            fadeOut(duration: duration,
                    completion: completion)
        } else {
            fadeIn(duration: duration,
                   completion: completion)
        }
    }
    func fadeOut(duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: {
                        self.alpha = 0.0
        },
                       completion: { isFinished in
                        self.isHidden = isFinished
                        completion?(isFinished)
        })
    }
    public func fadeIn(
        duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration,
                       animations: {
                        self.alpha = 1.0
        },
                       completion: completion)
    }
}
