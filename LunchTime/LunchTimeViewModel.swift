//
// Created by jarvis on 12/27/21.
//

import Foundation

enum CalendarDataError: Error {
    case metadataGeneration
}

protocol LunchTimeViewModel {
    var days: [Day] { get }
    var numberOfWeeksInStartDate: Int { get }

    func initializeDaysFromStartDate() -> [Day]
    func loadDaysOfNextMonth()
}

class CalendarViewModel: LunchTimeViewModel {
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()

    private let calendar = Calendar(identifier: .gregorian)

    private(set) var days: [Day] = []
    var numberOfWeeksInStartDate: Int {
        get {
            calendar.range(of: .weekOfMonth, in: .month, for: startDate)?.count ?? 0
        }
    }

    var startDate: Date

    init(startDate: Date) {
        self.startDate = startDate

        days = initializeDaysFromStartDate()
    }

    func initializeDaysFromStartDate() -> [Day] {
        guard let metadata = try? generateMonth(for: startDate) else {
            fatalError("An error occurred when generating the metadata for \(startDate)")
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        var days = [Day]()
        for day in 1..<(numberOfDaysInMonth + offsetInInitialRow) {
            let dayOffset = day >= offsetInInitialRow ? day - offsetInInitialRow : -(offsetInInitialRow - day)
            guard let newDay = try? generateDay(offsetBy: dayOffset, for: firstDayOfMonth) else { continue }

            days.append(newDay)
        }

        return days
    }

    func loadDaysOfNextMonth() {
        guard let firstDayOfNextMonth = calendar.date(byAdding: .day, value: 1, to: days[days.count - 1].date) else {
            return
        }

        guard let metadata = try? generateMonth(for: firstDayOfNextMonth) else {
            fatalError("An error occurred when generating the metadata for \(firstDayOfNextMonth)")
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        var newDays = [Day]()

        for i in 0..<numberOfDaysInMonth {
            guard let newDate = calendar.date(byAdding: .day, value: i, to: firstDayOfNextMonth) else {
                fatalError("An error occurred when generating the metadata for \(firstDayOfNextMonth)")
            }

            let newDay = Day(
                    date: newDate,
                    number: dateFormatter.string(from: newDate)
            )
            newDays.append(newDay)
        }

        days.append(contentsOf: newDays)
    }

    private func generateMonth(for baseDate: Date) throws -> Month {
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

    private func generateDay(offsetBy dayOffset: Int, for baseDate: Date) throws -> Day {
        guard let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) else {
            throw CalendarDataError.metadataGeneration
        }

        return Day(
                date: date,
                number: dateFormatter.string(from: date)
        )
    }
}