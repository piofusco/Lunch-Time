import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .label
        return label
    }()

    private lazy var menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(numberLabel)
        contentView.addSubview(monthLabel)
        contentView.addSubview(menuLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            monthLabel.heightAnchor.constraint(equalToConstant: 15),

            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            menuLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor),
            menuLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        monthLabel.isHidden = true
        monthLabel.text = ""
        numberLabel.text = ""
        numberLabel.textColor = .label
        menuLabel.text = ""
    }

    func setup(numberText: String, date: Date, isToday: Bool, monthText: String?, menuText: String?) {
        numberLabel.text = numberText

        contentView.backgroundColor = isToday ? UIColor.orange : UIColor.white
        numberLabel.textColor = isToday ? .white : .label
        monthLabel.textColor = isToday ? .white : .label
        menuLabel.textColor = isToday ? .white : .label

        if let monthText = monthText {
            monthLabel.text = monthText
        }

        if let menuText = menuText {
            menuLabel.text = menuText
        }
    }
}
