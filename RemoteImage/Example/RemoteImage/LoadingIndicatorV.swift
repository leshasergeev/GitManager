//
//  DownloadedImageView.swift
//  RemoteImage_Example
//
//  Created by Aleksei Sergeev on 20.07.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import RemoteImage

final class LoadingIndicatorV: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        layer.cornerRadius = bounds.height / 2
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingIndicatorV: LoadingIndicator {
    func startLoading() {
        print("Starting download...")
    }

    func stopLoading() {
        print("Stopping download...")
    }
}
