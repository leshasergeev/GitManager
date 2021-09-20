//
//  UIActivityIndicatorView+LoadingIndicator.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 31.08.2021.
//

import RemoteImage
import UIKit

extension UIActivityIndicatorView: LoadingIndicator {
    public func startLoading() {
        startAnimating()
    }

    public func stopLoading() {
        stopAnimating()
    }
}
