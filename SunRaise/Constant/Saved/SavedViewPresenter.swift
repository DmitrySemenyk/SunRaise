//
//  WhatToWatch
//
//  Created by Egor Afanasenko on 10/12/17.
//  Copyright © 2017 WhatToWatch Inc. All rights reserved.
//


import Foundation

protocol SavedViewPresenter: class {

    func moveBack()

    func numberOfSections() -> Int

    func numberOfObjects(in section: Int) -> Int

    func contentForObject(at indexPath: IndexPath) -> Result

    func selectRow(at indexPath: IndexPath)

    func setup()

}
