//
// Created by jarvis on 12/27/21.
//

import Foundation

enum CalendarDataError: Error {
    case metadataGeneration
}

protocol LunchTimeViewModel {
    var days: [Day] { get }
    var selectedDate: Date { get set }
    var numberOfWeeksInStartDate: Int { get }

    func initializeDaysFromStartDate() -> [Day]
    func addDaysOfNextMonth(date: Date)
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
    var selectedDate: Date

    init(startDate: Date) {
        self.startDate = startDate

        selectedDate = startDate
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

            days.append(generateDay(offsetBy: dayOffset, for: firstDayOfMonth))
        }

        return days
    }

    func addDaysOfNextMonth(date: Date) {
        guard let metadata = try? generateMonth(for: date) else {
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

    private func generateDay(offsetBy dayOffset: Int, for baseDate: Date) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate

        return Day(
                date: date,
                number: dateFormatter.string(from: date),
                isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
        )
    }
}