import UIKit
import MNTagView

class ExpandableTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ExpandableTableViewCell"
    
    var isExpand = false
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        return stackView
    }()

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.1404079861, green: 0.1404079861, blue: 0.1404079861, alpha: 1)
        label.setContentHuggingPriority(.init(rawValue: 200), for: .horizontal)
        return label
    }()

    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 0.3382260101, green: 0.3382260101, blue: 0.3382260101, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let expandableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .cyan
        return view
    }()
    
    lazy var tagListView: TagListViewUIKit = {
        let view = TagListViewUIKit()
        view.addTags(titles: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        contentView.addSubview(stackView)
        [mainStackView, expandableView].forEach { stackView.addArrangedSubview($0) }
        [titleLabel, chevronImageView].forEach { mainStackView.addArrangedSubview($0) }
        expandableView.addSubview(tagListView)
        setConstraints()
        set()
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18),
            tagListView.topAnchor.constraint(equalTo: expandableView.topAnchor),
            tagListView.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor),
            tagListView.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor),
            tagListView.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor)
        ])
    }

    func set() {
        isExpand.toggle()
        titleLabel.text = "test title"
        expandableView.isHidden = !isExpand
        chevronImageView.image = (isExpand ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down"))?.withRenderingMode(.alwaysTemplate)
    }
}

extension ExpandableTableViewCell: TagViewDelegate {
    func removeButtonPressed(_ tag: TagSubView) {
        
    }
    
    func tagPressed(_ tag: TagSubView) {
        print("tag pressed \(tag.model.title)")
    }

}
