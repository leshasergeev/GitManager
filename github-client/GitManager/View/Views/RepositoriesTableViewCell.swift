//
//  RepositoriesTableViewCell.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 06.08.2021.
//

import RemoteImage
import UIKit

class RepositoriesTableViewCell: UITableViewCell {

    private let repositoryNameFontHeight: CGFloat
    private let ownersNameHeight: CGFloat
    private let itemsGapValue: CGFloat
    private let starsHeight: CGFloat

    // MARK: - Avatar Relative Properties: 'start'
    static let avatarSize = CGSize(width: 30, height: 30)

    static let imageProcessor = RoundCornerImageProcessor(targetSize: avatarSize,
                                                          cornerRadius: avatarSize.height * 0.5)

    static let placeholderImage = UIImage(named: "avatar_placeholder")

    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    // MARK: 'finish' -

    private let avatar: UIImageView = {
        let image = UIImageView(frame: .zero)
        return image
    }()

    private lazy var ownersName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "darkGray")
        label.font = UIFont.systemFont(ofSize: ownersNameHeight)
        label.textAlignment = .left
        return label
    }()

    private lazy var languageLabel: UILabel = {
        let language = UILabel(frame: .zero)
        language.textColor = UIColor(named: "darkGray")?.withAlphaComponent(0.6)
        language.font = UIFont.systemFont(ofSize: starsHeight)
        language.textAlignment = .left
        return language
    }()

    private lazy var repositoryName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "darkGray")
        label.font = UIFont.boldSystemFont(ofSize: repositoryNameFontHeight)
        label.numberOfLines = 2
        return label
    }()

    private lazy var repositoryDescription: UILabel = {
        let description = UILabel(frame: .zero)
        description.lineBreakMode = .byWordWrapping
        description.numberOfLines = 3
        description.textColor = UIColor(named: "darkGray")
        return description
    }()

    private lazy var starsLabel: UILabel = {
        let stars = UILabel(frame: .zero)
        stars.font = UIFont.systemFont(ofSize: starsHeight)
        stars.textColor = UIColor(named: "darkGray")?.withAlphaComponent(0.6)
        stars.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return stars
    }()

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.repositoryNameFontHeight = 24
        self.ownersNameHeight = 20
        self.itemsGapValue = 10
        self.starsHeight = 20

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()

        avatar.translatesAutoresizingMaskIntoConstraints = false
        ownersName.translatesAutoresizingMaskIntoConstraints = false
        repositoryName.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        repositoryDescription.translatesAutoresizingMaskIntoConstraints = false
        starsLabel.translatesAutoresizingMaskIntoConstraints = false

        setViewsConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCell(withRepository repository: Repository) {

        ownersName.text = repository.owner.ownersName
        repositoryName.text = repository.name
        languageLabel.text = repository.language
        starsLabel.text = "☆" + String(repository.stars)
        repositoryDescription.text = repository.description

        self.avatar.image = nil
        self.avatar.setImage(with: URL(string: repository.owner.avatarURL),
                             placeholder: RepositoriesTableViewCell.placeholderImage,
                             loadingIndicator: loadingIndicator,
                             imageProcessor: RepositoriesTableViewCell.imageProcessor)
    }

    private func addSubviews() {
        [avatar, ownersName, repositoryName, repositoryDescription, starsLabel, languageLabel].forEach { contentView.addSubview($0) }
    }

    private func setViewsConstraints() {
        setConstraintsForImage()
        setConstraintsForOwnersNameLabel()
        setConstraintsForRepositoryName()
        setConstraintsForRepositoryDescription()
        setConstraintsForStarsLabel()
        setConstraintsForLanguageLabel()
    }

    private func setConstraintsForImage() {
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: itemsGapValue),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: itemsGapValue),
            avatar.heightAnchor.constraint(equalToConstant: Self.avatarSize.height),
            avatar.widthAnchor.constraint(equalToConstant: Self.avatarSize.width)
        ])
    }

    private func setConstraintsForOwnersNameLabel() {
        NSLayoutConstraint.activate([
            ownersName.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            ownersName.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: itemsGapValue),
            ownersName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -itemsGapValue)
        ])
    }

    private func setConstraintsForRepositoryName() {
        NSLayoutConstraint.activate([
            repositoryName.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: itemsGapValue),
            repositoryName.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            repositoryName.trailingAnchor.constraint(equalTo: ownersName.trailingAnchor)
        ])
    }

    private func setConstraintsForLanguageLabel() {
        NSLayoutConstraint.activate([
            languageLabel.bottomAnchor.constraint(equalTo: starsLabel.bottomAnchor),
            languageLabel.topAnchor.constraint(equalTo: starsLabel.topAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: ownersName.trailingAnchor),
            languageLabel.leadingAnchor.constraint(equalTo: starsLabel.trailingAnchor,
                                                   constant: itemsGapValue)
        ])
    }

    private func setConstraintsForRepositoryDescription() {
        NSLayoutConstraint.activate([
            repositoryDescription.topAnchor.constraint(equalTo: repositoryName.bottomAnchor,
                                                       constant: itemsGapValue),
            repositoryDescription.bottomAnchor.constraint(equalTo: starsLabel.topAnchor,
                                                          constant: -itemsGapValue),
            repositoryDescription.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            repositoryDescription.trailingAnchor.constraint(equalTo: ownersName.trailingAnchor)
        ])
    }

    private func setConstraintsForStarsLabel() {
        NSLayoutConstraint.activate([
            starsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -itemsGapValue),
            starsLabel.leadingAnchor.constraint(equalTo: repositoryDescription.leadingAnchor)
        ])
    }
}

extension RepositoriesTableViewCell: CellWithIdentifier {
    static var cellIdentifier: String {
        String(describing: self)
    }
}
