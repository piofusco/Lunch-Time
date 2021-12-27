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
    private let dispatchQueue: DispatchQueueProtocol

    init(viewModel: LunchViewModel, dispatchQueue: DispatchQueueProtocol) {
        self.viewModel = viewModel
        self.dispatchQueue = dispatchQueue

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
            guard let self = self else { return }

            switch result {
            case .success(let shouldReload):
                if shouldReload {
                    self.dispatchQueue.async {
                        self.tableView.reloadData()
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
