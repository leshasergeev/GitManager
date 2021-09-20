//
//  SignOutButton.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 19.09.2021.
//

import UIKit

class SignOutButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 15
        backgroundColor = UIColor(named: "darkGray")
        setTitleColor(UIColor(named: "white"), for: .normal)
        let title = NSLocalizedString("Sign Out", comment: "")
        setTitle(title, for: .normal)
        setupShadow()
    }

    private func setupShadow() {
        layer.shadowColor = UIColor(named: "darkGray")?.cgColor
        layer.shadowOffset = .init(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
}
