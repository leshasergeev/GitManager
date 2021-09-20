//
//  UserAdditionalInfoView.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 19.09.2021.
//

import UIKit

protocol UserAdditionalInfoView: UserInfoView {
    func setAdditionalInfo(followers: Int, following: Int, email: String?, location: String?)
}

class UserAdditionalInfoViewImpl: UserInfoView {

    private let itemsGapValue: CGFloat
    private let locationHight: CGFloat
    private let emailHeight: CGFloat
    private let followersHeight: CGFloat

    private let followersStrAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: UIColor(named: "black") ?? .black,
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
    ]

    private let locationLabel: UILabel = {
        let fullName = UILabel(frame: .zero)
        fullName.textAlignment = .center
        fullName.textColor = UIColor(named: "darkGray")
        return fullName
    }()

    private let emailLabel: UILabel = {
        let fullName = UILabel(frame: .zero)
        fullName.textAlignment = .center
        fullName.textColor = UIColor(named: "darkGray")
        return fullName
    }()

    private let followersLabel: UILabel = {
        let companyName = UILabel(frame: .zero)
        companyName.textAlignment = .center
        companyName.textColor = UIColor(named: "darkGray")
        return companyName
    }()

    override init(frame: CGRect) {
        self.itemsGapValue = CurrentUserProfileViewController.itemsGapValue
        self.locationHight = CurrentUserProfileViewController.locationHight
        self.emailHeight = CurrentUserProfileViewController.emailHeight
        self.followersHeight = CurrentUserProfileViewController.followersHeight

        super.init(frame: frame)

        addSubveiws()
        configureConstraints()

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubveiws() {
        [
            locationLabel,
            emailLabel,
            followersLabel
        ].forEach { addSubview($0) }
    }

    private func configureConstraints() {
        setConstraintsForLocationLabel()
        setConstraintsForEmailLabel()
        setConstraintsForFollowersLabel()
    }

    private func setConstraintsForLocationLabel() {
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                               constant: itemsGapValue),
            locationLabel.heightAnchor.constraint(equalToConstant: locationHight),
            locationLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                   constant: itemsGapValue),
            locationLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                    constant: itemsGapValue)
        ])
    }

    private func setConstraintsForEmailLabel() {
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: itemsGapValue),
            emailLabel.heightAnchor.constraint(equalToConstant: emailHeight),
            emailLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                constant: itemsGapValue),
            emailLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -itemsGapValue)
        ])
    }

    private func setConstraintsForFollowersLabel() {
        NSLayoutConstraint.activate([
            followersLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -itemsGapValue),
            followersLabel.heightAnchor.constraint(equalToConstant: followersHeight),
            followersLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                    constant: itemsGapValue),
            followersLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -itemsGapValue)
        ])
    }
}

extension UserAdditionalInfoViewImpl: UserAdditionalInfoView {
    func setAdditionalInfo(followers: Int, following: Int, email: String?, location: String?) {
        let followersStr = NSMutableAttributedString(string: "\(followers)", attributes: followersStrAttributes)
        let followingStr = NSMutableAttributedString(string: "\(following)", attributes: followersStrAttributes)
        let attributedFollowersStr = NSMutableAttributedString()
        attributedFollowersStr.append(followersStr)
        attributedFollowersStr.append(NSAttributedString(string: " followers • "))
        attributedFollowersStr.append(followingStr)
        attributedFollowersStr.append(NSAttributedString(string: " following"))
        followersLabel.attributedText = attributedFollowersStr

        if let email = email {
            emailLabel.text = email
        } else {
            emailLabel.text = NSLocalizedString("Email Is Unknown", comment: "")
        }

        if let location = location {
            locationLabel.text = location
        } else {
            locationLabel.text = NSLocalizedString("Location Is Unknown", comment: "")
        }
    }
}
