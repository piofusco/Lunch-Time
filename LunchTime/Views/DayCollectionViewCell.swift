import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    private lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.orange
        return view
    }()

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

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(circleView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(monthLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let size = traitCollection.horizontalSizeClass == .compact ? min(min(frame.width, frame.height) - 10, 60) : 45

        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            monthLabel.heightAnchor.constraint(equalToConstant: 15),

            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            circleView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            circleView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: size),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor)
        ])

        circleView.layer.cornerRadius = size / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        numberLabel.text = ""
        numberLabel.textColor = .label
        circleView.isHidden = true
        monthLabel.isHidden = true
        monthLabel.text = ""
    }

    func setup(numberText: String, date: Date, isToday: Bool, monthText: String?) {
        numberLabel.text = numberText

        circleView.isHidden = isToday ? false : true
        numberLabel.textColor = isToday ? .white : .label

        if let monthText = monthText {
            monthLabel.isHidden = false
            monthLabel.text = monthText
        }
    }
}
