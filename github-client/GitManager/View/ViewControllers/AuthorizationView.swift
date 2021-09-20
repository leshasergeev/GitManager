//
//  AuthorizationView.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 01.09.2021.
//

import UIKit
import WebKit

protocol AuthorizationView: AnyObject {
    func showAuthorizationWindow(withURLRequest urlRequest: URLRequest)
}

class AuthorizationViewController: UIViewController, AuthorizationView {

    private let presenter: AuthorizationPresenter

    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    private lazy var webViewHiddenConstraint = webView.topAnchor.constraint(equalTo: view.bottomAnchor)
    private lazy var webViewShowedConstraint = webView.topAnchor.constraint(equalTo: view.topAnchor)

    private lazy var gitSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "orange")
        button.setTitle(NSLocalizedString("Sign In with GitHub", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "gray"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(gitSignInButtonPressed), for: .touchUpInside)
        return button
    }()

    private let copyrightLabel: UILabel = {
        let copyright = UILabel(frame: .zero)
        copyright.text = "Copyright 2021 | Built by @iBamboola"
        copyright.textColor = UIColor(named: "black")
        copyright.textAlignment = .center
        copyright.font = UIFont.systemFont(ofSize: 16)
        return copyright
    }()

    private let welcomingLabel: UILabel = {
        let welcoming = UILabel(frame: .zero)
        welcoming.text = NSLocalizedString("Welcome to Git Manager!", comment: "")
        welcoming.textColor = UIColor(named: "gray")
        welcoming.textAlignment = .center
        welcoming.font = UIFont.systemFont(ofSize: 22)
        return welcoming
    }()

    private let welcomingImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(named: "github_logo")
        return image
    }()

    init(presenter: AuthorizationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)

        self.welcomingImage.translatesAutoresizingMaskIntoConstraints = false
        self.gitSignInButton.translatesAutoresizingMaskIntoConstraints = false
        self.copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.welcomingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.webView.translatesAutoresizingMaskIntoConstraints = false

        self.webView.navigationDelegate = self
        self.webView.isHidden = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func gitSignInButtonPressed() {
        presenter.signInWithGitButtonTapped()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "darkGray")
        addSubviews()
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func addSubviews() {
        [welcomingImage, gitSignInButton, copyrightLabel, welcomingLabel, webView].forEach { view.addSubview($0) }
    }

    private func setConstraints() {
        setConstraintsForSingInImage()
        setConstraintsForSignInButton()
        setConstraintsForCopyrightLabel()
        setConstraintsForWelcomingLabel()
        setConstraintsForWebView()
    }

    private func setConstraintsForSingInImage() {
        NSLayoutConstraint.activate([
            welcomingImage.heightAnchor.constraint(equalToConstant: 300),
            welcomingImage.widthAnchor.constraint(equalTo: welcomingImage.heightAnchor),
            welcomingImage.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -120),
            welcomingImage.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    private func setConstraintsForSignInButton() {
        NSLayoutConstraint.activate([
            gitSignInButton.topAnchor.constraint(equalTo: welcomingLabel.bottomAnchor, constant: 20),
            gitSignInButton.widthAnchor.constraint(equalToConstant: 160),
            gitSignInButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    private func setConstraintsForCopyrightLabel() {
        NSLayoutConstraint.activate([
            copyrightLabel.heightAnchor.constraint(equalToConstant: 40),
            copyrightLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            copyrightLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            copyrightLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5)
        ])
    }

    private func setConstraintsForWelcomingLabel() {
        NSLayoutConstraint.activate([
            welcomingLabel.topAnchor.constraint(equalTo: welcomingImage.bottomAnchor, constant: -20),
            welcomingLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            welcomingLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5)
        ])
    }

    private func setConstraintsForWebView() {
        NSLayoutConstraint.activate([
            webView.heightAnchor.constraint(equalTo: view.heightAnchor),
            webViewHiddenConstraint,
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func showAuthorizationWindow(withURLRequest urlRequest: URLRequest) {
        webView.isHidden = false
        webView.load(urlRequest)
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            self.webViewHiddenConstraint.isActive = false
            self.webViewShowedConstraint.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension AuthorizationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if presenter.processNavigation(toUrl: navigationAction.request.url) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
