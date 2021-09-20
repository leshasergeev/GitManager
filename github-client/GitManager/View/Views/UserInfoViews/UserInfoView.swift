//
//  UserInfoView.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 19.09.2021.
//

import UIKit

class UserInfoView: UIView {
    enum LoadingState {
        case start, stop
    }

    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    private let cornerRadius: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        setConstraintsForLoadingIndicator()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = cornerRadius
        setupShadow()
        backgroundColor = UIColor(named: "gray")
    }

    private func setupShadow() {
        layer.shadowColor = UIColor(named: "darkGray")?.cgColor
        layer.shadowOffset = .init(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }

    func setLoadingState(_ loadingState: LoadingState) {
        switch loadingState {
        case .start:
            loadingIndicator.isHidden = false
            loadingIndicator.startLoading()
        case . stop:
            loadingIndicator.stopLoading()
            loadingIndicator.isHidden = true
        }
    }

    private func setConstraintsForLoadingIndicator() {
        NSLayoutConstraint.activate([
            loadingIndicator.heightAnchor.constraint(equalToConstant: 60),
            loadingIndicator.widthAnchor.constraint(equalTo: loadingIndicator.heightAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
