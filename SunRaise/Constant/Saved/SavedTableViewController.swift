//
//  WhatToWatch
//
//  Created by Egor Afanasenko on 10/12/17.
//  Copyright © 2017 WhatToWatch Inc. All rights reserved.
//


import Foundation
import UIKit
import CoreData

class SavedTableViewController: UITableViewController {

    var presenter: SavedViewPresenter?

    private var backButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.setup()

        let nib = UINib(nibName: HistoryTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(tapBack(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        // REMOVE ON UPDATE
        tableView.allowsSelection = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        tableView.tableFooterView = UIView()

        backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_icon"), style: .plain, target: self, action: #selector(tapBack(_:)))
        backButton.tintColor = UIColor.black

        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }

    // Back transition function and disappear check

    @objc func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    // TableViewDataSource and TableViewDelegate methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfObjects(in: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = HistoryTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        if let cell = cell as? HistoryTableViewCell, let result = presenter?.contentForObject(at: indexPath) {
            cell.configure(with: result)
            return cell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? HistoryTableViewCell else {
            return
        }

        presenter?.selectRow(at: indexPath)
    }
}

extension SavedTableViewController: SavedView {
    
    func showLoading(begin: Bool) {
        if begin {
            self.showLoadingView(viewColor: .white, loadingColor: UIColor(hex: 0xde6363))
        } else {
            self.hideLoadingView()
        }
    }

    func show(movie: MovieViewData) {
        // TODO
    }

}
