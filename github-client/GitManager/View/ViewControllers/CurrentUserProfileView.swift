//
//  CurrentUserProfileView.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 17.09.2021.
//

import RemoteImage
import UIKit

protocol CurrentUserProfileView: AnyObject {
    func setupViewWithProfile(_ profile: UserProfile)
    func setupViewWithError()
}

class CurrentUserProfileViewController: UIViewController, CurrentUserProfileView {

    static let itemsGapValue: CGFloat = 15
    static let fullNameHeight: CGFloat = 30
    static let accountNameHeight: CGFloat = 30
    static let companyNameHeingt: CGFloat = 20
    static let contactsInfoHeight: CGFloat = 25
    static let followersInfoHeight: CGFloat = 25
    static let locationHight: CGFloat = 20
    static let emailHeight: CGFloat = 20
    static let followersHeight: CGFloat = 20

    private let presenter: CurrentUserProfilePresenter

    private let barImage = UIImage(named: "current_user_bar_logo")

    // MARK: - Avatar Relative Properties: 'start'

    static let avatarImageHeight: CGFloat = 150

    static let avatarImageSize = CGSize(width: avatarImageHeight, height: avatarImageHeight)

    static let imageProcessor = RoundCornerImageProcessor(targetSize: avatarImageSize,
                                                          cornerRadius: avatarImageSize.height * 0.5)

    static let placeholderImage = UIImage(named: "avatar_placeholder")

    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    // MARK: 'finish' -

    private let errorPlaceholder: UIImageView = {
        let errorPlaceholder = UIImageView(frame: .zero)
        errorPlaceholder.isHidden = true
        errorPlaceholder.image = UIImage(named: "error_placeholder")
        return errorPlaceholder
    }()

    private let userAdditionalInfoView: UserAdditionalInfoView = {
        let userInfo = UserAdditionalInfoViewImpl(frame: .zero)
        return userInfo
    }()

    private let userGeneralInfoView: UserGeneralInfoView = {
        let userInfo = UserGeneralInfoViewImpl(frame: .zero)
        return userInfo
    }()

    private lazy var signOutButton: SignOutButton = {
        let button = SignOutButton(frame: .zero)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()

    init(presenter: CurrentUserProfilePresenter) {

        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)

        setupTabBarItem()

        errorPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        userGeneralInfoView.translatesAutoresizingMaskIntoConstraints = false
        userAdditionalInfoView.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "white")

        addSubveiws()
        configureConstraints()

        userGeneralInfoView.setLoadingState(.start)
        userAdditionalInfoView.setLoadingState(.start)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        presenter.readyToPresentUserInfo()
    }

    func setupViewWithProfile(_ profile: UserProfile) {
        userGeneralInfoView.setGeneralUserInfo(fullName: profile.fullName,
                                               companyName: profile.company,
                                               accountName: profile.accountName)

        userGeneralInfoView.avatarImage.image = nil
        userGeneralInfoView.avatarImage.setImage(with: URL(string: profile.avatarUrl),
                                                 placeholder: Self.placeholderImage,
                                                 loadingIndicator: loadingIndicator,
                                                 imageProcessor: Self.imageProcessor)
        userGeneralInfoView.setLoadingState(.stop)

        userAdditionalInfoView.setAdditionalInfo(followers: profile.followers,
                                                 following: profile.following,
                                                 email: profile.email,
                                                 location: profile.location)
        userAdditionalInfoView.setLoadingState(.stop)
    }

    func setupViewWithError() {
        let title = NSLocalizedString("Some Error with Receiving User's Profile Occurred", comment: "")
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okStr = NSLocalizedString("Ok", comment: "")
        alertVC.addAction(UIAlertAction(title: okStr, style: .cancel, handler: nil))
        present(alertVC, animated: true) {
            self.view.subviews.forEach { $0.isHidden = true }
            self.errorPlaceholder.isHidden = false
        }
    }

    private func setupTabBarItem() {
        tabBarItem.title = "Profile"
        tabBarItem.image = UIImage(named: "current_user_bar_logo")?.withRenderingMode(.alwaysOriginal)
    }

    @objc
    private func signOut() {
        presenter.signOutButtonTapped()
    }

    private func addSubveiws() {
        [
            errorPlaceholder,
            userGeneralInfoView,
            userAdditionalInfoView,
            signOutButton
        ].forEach { view.addSubview($0) }
    }

    private func configureConstraints() {
        setConstraintsForErrorPlaceholder()
        setConstraintsForUserGeneralInfoView()
        setConstraintsForUserAdditionalInfoView()
        setConstraintsForSignOutButton()
    }

    private func setConstraintsForErrorPlaceholder() {
        NSLayoutConstraint.activate([
            errorPlaceholder.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            errorPlaceholder.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            errorPlaceholder.heightAnchor.constraint(equalToConstant: 300),
            errorPlaceholder.widthAnchor.constraint(equalTo: errorPlaceholder.heightAnchor)
        ])
    }

    private func setConstraintsForUserGeneralInfoView() {
        NSLayoutConstraint.activate([
            userGeneralInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                     constant: Self.itemsGapValue),
            userGeneralInfoView.heightAnchor.constraint(equalToConstant: 300),
            userGeneralInfoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                                         constant: Self.itemsGapValue),
            userGeneralInfoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -Self.itemsGapValue)
        ])
    }

    private func setConstraintsForUserAdditionalInfoView() {
        NSLayoutConstraint.activate([
            userAdditionalInfoView.topAnchor.constraint(equalTo: userGeneralInfoView.bottomAnchor,
                                                        constant: Self.itemsGapValue),
            userAdditionalInfoView.heightAnchor.constraint(equalToConstant: 120),
            userAdditionalInfoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                                            constant: Self.itemsGapValue),
            userAdditionalInfoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                             constant: -Self.itemsGapValue)
        ])
    }

    private func setConstraintsForSignOutButton() {
        NSLayoutConstraint.activate([
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.topAnchor.constraint(equalTo: userAdditionalInfoView.bottomAnchor,
                                               constant: Self.itemsGapValue),
            signOutButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Self.itemsGapValue),
            signOutButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -Self.itemsGapValue)
        ])
    }
}
