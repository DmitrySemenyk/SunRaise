//
//  Extension+UIView.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 13/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    public static let defaultFadingAnimationDuration: TimeInterval = 1.0
    
    
    func addBottomLine(color: UIColor, height: CGFloat) {
        let bottomView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: height))
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.autoresizingMask = .flexibleWidth
        bottomView.backgroundColor = color
        self.addSubview(bottomView)
    }
    
    
    

    // MARK: - Public methods
    /// Updates the view visiblity.
    ///
    /// - Parameters:
    ///   - isHidden: The new view visibility.
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    public func animate(isHidden: Bool, duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            fadeOut(duration: duration,
                    completion: completion)
        } else {
            fadeIn(duration: duration,
                   completion: completion)
        }
    }

    /// Fade out the current view by animating the `alpha` to zero and update the `isHidden` flag accordingly.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    public func fadeOut(duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: {
                           self.alpha = 0.0
                       },
                       completion: { isFinished in
                           // Update `isHidden` flag accordingly:
                           //  - set to `true` in case animation was completly finished.
                           //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
                           self.isHidden = isFinished

                           completion?(isFinished)
        })
    }

    /// Fade in the current view by setting the `isHidden` flag to `false` and animating the `alpha` to one.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    public func fadeIn(duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            // Make sure our animation is visible.
            isHidden = false
        }

        UIView.animate(withDuration: duration,
                       animations: {
                           self.alpha = 1.0
                       },
                       completion: completion)
    }
}


