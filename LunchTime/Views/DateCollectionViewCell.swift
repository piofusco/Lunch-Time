import UIKit

class DateCollectionViewCell: UICollectionViewCell {
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(circleView)
        contentView.addSubview(numberLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let size = traitCollection.horizontalSizeClass == .compact ? min(min(frame.width, frame.height) - 10, 60) : 45

        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            circleView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            circleView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: size),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor)
        ])

        circleView.layer.cornerRadius = size / 2
    }

    func setup(numberText: String, date: Date, isToday: Bool) {
        numberLabel.text = numberText

        if isToday {
            circleView.isHidden = false
            numberLabel.textColor = .white
        } else {
            numberLabel.textColor = .label
            circleView.isHidden = true
        }
    }
}
