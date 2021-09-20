//
//  UserGeneralInfoView.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 19.09.2021.
//

import UIKit

protocol UserGeneralInfoView: UserInfoView {
    var avatarImage: UIImageView { get set }
    func setGeneralUserInfo(fullName: String?, companyName: String?, accountName: String)
}

class UserGeneralInfoViewImpl: UserInfoView {

    private let itemsGapValue: CGFloat
    private let fullNameHeight: CGFloat
    private let accountNameHeight: CGFloat
    private let companyNameHeingt: CGFloat
    private let avatarImageHeight: CGFloat

    var avatarImage = UIImageView(frame: .zero)

    private let fullNameLabel: UILabel = {
        let fullName = UILabel(frame: .zero)
        fullName.textAlignment = .center
        fullName.textColor = UIColor(named: "darkGray")
        return fullName
    }()

    private let companyNameLabel: UILabel = {
        let companyName = UILabel(frame: .zero)
        companyName.textAlignment = .center
        companyName.textColor = UIColor(named: "darkGray")
        return companyName
    }()

    private let accountNameLabel: UILabel = {
        let accountName = UILabel(frame: .zero)
        accountName.textAlignment = .center
        accountName.textColor = UIColor(named: "orange")
        return accountName
    }()

    override init(frame: CGRect) {
        self.itemsGapValue = CurrentUserProfileViewController.itemsGapValue
        self.fullNameHeight = CurrentUserProfileViewController.fullNameHeight
        self.accountNameHeight = CurrentUserProfileViewController.accountNameHeight
        self.companyNameHeingt = CurrentUserProfileViewController.companyNameHeingt
        self.avatarImageHeight = CurrentUserProfileViewController.avatarImageHeight

        super.init(frame: frame)

        addSubveiws()
        configureConstraints()

        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        accountNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubveiws() {
        [
            avatarImage,
            fullNameLabel,
            accountNameLabel,
            companyNameLabel
        ].forEach { addSubview($0) }
    }

    private func configureConstraints() {
        setConstraintsForAvatarImage()
        setConstraintsForFullNameLabel()
        setConstraintsForCompanyNameLabel()
        setConstraintsForAccountNameLabel()
        setConstraintsForAvatarImage()
    }

    private func setConstraintsForAvatarImage() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                             constant: itemsGapValue),
            avatarImage.heightAnchor.constraint(equalToConstant: avatarImageHeight),
            avatarImage.widthAnchor.constraint(equalTo: avatarImage.heightAnchor),
            avatarImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setConstraintsForFullNameLabel() {
        NSLayoutConstraint.activate([
            fullNameLabel.bottomAnchor.constraint(equalTo: companyNameLabel.topAnchor, constant: -itemsGapValue),
            fullNameLabel.heightAnchor.constraint(equalToConstant: fullNameHeight),
            fullNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                   constant: itemsGapValue),
            fullNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -itemsGapValue)
        ])
    }

    private func setConstraintsForAccountNameLabel() {
        NSLayoutConstraint.activate([
            accountNameLabel.bottomAnchor.constraint(equalTo: fullNameLabel.topAnchor, constant: -itemsGapValue),
            accountNameLabel.heightAnchor.constraint(equalToConstant: accountNameHeight),
            accountNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                      constant: itemsGapValue),
            accountNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -itemsGapValue)
        ])
    }

    private func setConstraintsForCompanyNameLabel() {
        NSLayoutConstraint.activate([
            companyNameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -itemsGapValue),
            companyNameLabel.heightAnchor.constraint(equalToConstant: companyNameHeingt),
            companyNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                      constant: itemsGapValue),
            companyNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -itemsGapValue)
        ])
    }
}

extension UserGeneralInfoViewImpl: UserGeneralInfoView {
    func setGeneralUserInfo(fullName: String?, companyName: String?, accountName: String) {
        if let name = fullName {
            fullNameLabel.text = name
        } else {
            fullNameLabel.text = NSLocalizedString("Name Is Unknown", comment: "")
        }

        if let company = companyName {
            companyNameLabel.text = "\(NSLocalizedString("Working at", comment: "")) \(company)"
        } else {
            companyNameLabel.text = NSLocalizedString("Working somewhere", comment: "")
        }

        accountNameLabel.text = accountName
    }
}
