//
//  Extension+UIImageView.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 13/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
