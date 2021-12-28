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

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()

    private let calendar = Calendar(identifier: .gregorian)
    private var days = [Day]()

    private let mainQueue: MainQueue
    private var startDate: Date
    private var selectedDate: Date

    init(mainQueue: MainQueue, startDate: Date = Date()) {
        self.mainQueue = mainQueue
        self.startDate = startDate
        self.selectedDate = startDate

        super.init(nibName: nil, bundle: nil)

        days = generateDaysInMonth(for: startDate)
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
        days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else {
            fatalError("Unable to dequeue DateCollectionViewCell")
        }

        cell.day = day
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !collectionView.visibleCells.contains(cell) && indexPath.row == days.count - 1 else {
            return
        }

        mainQueue.async { [weak self] in
            guard let self = self else { return }

            let oldTotal = self.days.count
            guard let firstDayOfNextMonth = self.calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: self.days[self.days.count - 1].date) else {
                return
            }
            self.days += self.generateDaysForNextMonth(for: firstDayOfNextMonth)

            print("old: \(oldTotal)")
            print("new: \(self.days.count)")

            var newIndexPaths = [IndexPath]()
            for i in oldTotal..<self.days.count {
                newIndexPaths.append(IndexPath(row: i, section: 0))
            }

            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfWeeksInStartDate = calendar.range(of: .weekOfMonth, in: .month, for: startDate)?.count ?? 0

        let height = Int(collectionView.frame.height) / numberOfWeeksInStartDate
        let width = Int(collectionView.frame.width / 7)
        return CGSize(width: width, height: height)
    }
}

private extension CalendarViewController {
    func generateDaysForNextMonth(for date: Date) -> [Day] {
        guard let metadata = try? monthMetadata(for: date) else {
            fatalError("An error occurred when generating the metadata for \(date)")
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        var newDays = [Day]()

        for i in 0..<numberOfDaysInMonth {
            guard let newDate = calendar.date(byAdding: .day, value: i, to: date) else {
                fatalError("An error occurred when generating the metadata for \(date)")
            }

            let newDay = Day(
                    date: newDate,
                    number: dateFormatter.string(from: newDate),
                    isSelected: false
            )
            newDays.append(newDay)
        }

        return newDays
    }

    func generateDaysInMonth(for date: Date) -> [Day] {
        guard let metadata = try? monthMetadata(for: date) else {
            fatalError("An error occurred when generating the metadata for \(date)")
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        let days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let dayOffset = day >= offsetInInitialRow ? day - offsetInInitialRow : -(offsetInInitialRow - day)

            return generateDay(
                    offsetBy: dayOffset,
                    for: firstDayOfMonth
            )
        }

        return days
    }

    func monthMetadata(for baseDate: Date) throws -> Month {
        guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate)) else {
            throw CalendarDataError.metadataGeneration
        }

        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        return Month(
                numberOfDays: numberOfDaysInMonth,
                firstDay: firstDayOfMonth,
                firstDayWeekday: firstDayWeekday
        )
    }

    func generateDay(offsetBy dayOffset: Int, for baseDate: Date) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate

        return Day(
                date: date,
                number: dateFormatter.string(from: date),
                isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
        )
    }

    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard let lastDayInMonth = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth) else {
            return []
        }

        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else { return [] }

        let days: [Day] = (1...additionalDays).map {
            generateDay(
                    offsetBy: $0,
                    for: lastDayInMonth
            )
        }

        return days
    }

    enum CalendarDataError: Error {
        case metadataGeneration
    }
}
