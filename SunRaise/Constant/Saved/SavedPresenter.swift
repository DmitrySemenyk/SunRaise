//
//  WhatToWatch
//
//  Created by Egor Afanasenko on 10/12/17.
//  Copyright © 2017 WhatToWatch Inc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SavedPresenter {

    private weak var view: SavedView?

    private let router: SavedRouter
    private let movieAPI: MovieAPI
    private let fetchedResultsController: NSFetchedResultsController<Result>

    init(view: SavedView, router: SavedRouter, movieAPI: MovieAPI, fetchedResultsController: NSFetchedResultsController<Result>) {
        self.view = view
        self.movieAPI = movieAPI
        self.fetchedResultsController = fetchedResultsController
        self.router = router
    }

    func setup() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
}

extension SavedPresenter: SavedViewPresenter {

    func moveBack() {
        router.route(to: .previous, from: view as! UIViewController)
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfObjects(in section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }

        return sections[section].numberOfObjects
    }

    func contentForObject(at indexPath: IndexPath) -> Result {
        let result = fetchedResultsController.object(at: indexPath)
        return result
    }

    func selectRow(at indexPath: IndexPath) {
        view?.showLoading(begin: true)

        let result = fetchedResultsController.object(at: indexPath)

        movieAPI.fetchMovieDetails(movieId: result.movieId, success: {
            [weak self]
            movie in

            guard let strongSelf = self else {
                return
            }

            let movieViewData = MovieViewData(movie: movie)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                strongSelf.view?.showLoading(begin: false)
                strongSelf.router.route(to: .movie(movieViewData), from: strongSelf.view as! UIViewController)
            }
        }, failure: { error in
            print(error)
        })
    }

}
