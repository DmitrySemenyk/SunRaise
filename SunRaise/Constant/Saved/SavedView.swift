//
//  WhatToWatch
//
//  Created by Egor Afanasenko on 10/12/17.
//  Copyright © 2017 WhatToWatch Inc. All rights reserved.
//


protocol SavedView: class, LoadableView {

    func show(movie: MovieViewData)

}
