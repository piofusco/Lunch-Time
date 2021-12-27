//
//  ScheduleListViewController.swift
//  LunchTime
//
//  Created by jarvis on 12/26/21.
//
//

import UIKit

class ScheduleViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.rowHeight = 60
        return tableView
    }()

    private let viewModel: LunchViewModel
    private let mainQueue: MainQueue

    init(viewModel: LunchViewModel, mainQueue: MainQueue) {
        self.viewModel = viewModel
        self.mainQueue = mainQueue

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        super.loadView()

        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getMenusFromAPI { [weak self] result in
            guard let mainQueue = self?.mainQueue,
                  let tableView = self?.tableView else { return }

            switch result { 
            case .success(let shouldReload):
                if shouldReload {
                    mainQueue.async {
                        tableView.reloadData()
                    }
                }
            case .failure(let error): print(error)
            }
        }
    }
}

extension ScheduleViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.menus.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "DailyMenuCell")
        cell.textLabel?.text = viewModel.menus[indexPath.row].dayOfTheWeek
        cell.detailTextLabel?.text = viewModel.menus[indexPath.row].description
        return cell
    }
}
