//
//  PlaceholderView.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 12.08.2021.
//

import UIKit

class PlaceholderView: UIView {

    private let spacing: CGFloat = 10

    private let fontSize: CGFloat = 20

    private lazy var placeholderImage: UIImageView = {
        let placeholder = UIImageView(image: UIImage(named: "octocat"))
        placeholder.contentMode = .scaleAspectFit
        return placeholder
    }()

    private lazy var messageLabel: UILabel = {
        let message = UILabel(frame: .zero)
        message.font = UIFont.boldSystemFont(ofSize: self.fontSize)
        message.text = NSLocalizedString("Something went wrong", comment: "")
        message.textColor = UIColor(named: "darkGray")
        message.textAlignment = .center
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        return message
    }()

    init() {
        super.init(frame: .zero)
        addSubviews()
        configureConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String {
      get { messageLabel.text ?? "" }
      set { messageLabel.text = newValue }
    }

    private func addSubviews() {
        [placeholderImage, messageLabel].forEach { self.addSubview($0) }
    }

    private func configureConstraints() {
        setConstraintsForPlaceholderImage()
        setConstraintsForMessageLabel()
    }

    private func setConstraintsForMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: spacing),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setConstraintsForPlaceholderImage() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderImage.topAnchor.constraint(equalTo: topAnchor),
            placeholderImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderImage.heightAnchor.constraint(equalTo: placeholderImage.widthAnchor, multiplier: 0.832)
        ])
    }
}
