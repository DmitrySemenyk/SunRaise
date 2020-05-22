//
//  WhatToWatch
//
//  Created by Egor Afanasenko on 10/12/17.
//  Copyright © 2017 WhatToWatch Inc. All rights reserved.
//

import Foundation
import UIKit

struct SavedRouter: Router {

    enum Point {
        case movie(MovieViewData)
        case previous
    }

    func route(to point: SavedRouter.Point, from context: UIViewController) {
        switch point {
        case .movie(_):
            let vc = ControllerHelper.instantiateViewController(identifier: "ResultViewController")
            guard let resultVC = vc as? ResultViewController else {
                fatalError("Instantiated vc doesn't compatible with to ResultViewController type")
            }

            resultVC.isIntoQuiz = false

            context.navigationController?.pushViewController(resultVC, animated: true)
            
        case .previous:
            context.navigationController?.popViewController(animated: true)
        }
    }

}
