//
//  CalendarViewController.swift
//  LunchTime
//
//  Created by jarvis on 12/26/21.
//
//

import UIKit

class CalendarViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private let calendar = Calendar(identifier: .gregorian)

    private let viewModel: LunchTimeViewModel
    private let mainQueue: MainQueue

    init(viewModel: LunchTimeViewModel, mainQueue: MainQueue) {
        self.viewModel = viewModel
        self.mainQueue = mainQueue

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        super.loadView()

        navigationItem.title = "Calendar"

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = viewModel.days[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else {
            fatalError("Unable to dequeue DateCollectionViewCell")
        }

        cell.setup(
                numberText: day.number,
                date: day.date,
                isToday: calendar.isDate(day.date, inSameDayAs: Date())
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !collectionView.visibleCells.contains(cell) && indexPath.row == viewModel.days.count - 1 else {
            return
        }

        mainQueue.async { [weak self] in
            guard let self = self else { return }

            let oldTotal = self.viewModel.days.count
            self.viewModel.loadDaysOfNextMonth()

            var newIndexPaths = [IndexPath]()
            for i in oldTotal..<self.viewModel.days.count {
                newIndexPaths.append(IndexPath(row: i, section: 0))
            }

            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = Int(collectionView.frame.height) / viewModel.numberOfWeeksInStartDate
        let width = Int(collectionView.frame.width / 7)
        return CGSize(width: width, height: height)
    }
}
