//
//  TestingLoadingIndicator.swift
//  RemoteImageTests
//
//  Created by Aleksei Sergeev on 29.07.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import RemoteImage

enum IndicatorStates {
    case start, stop
}

enum IndicatorAppearingStates {
    case appear, dissapear
}

final class TestingLoadingIndicator: UIView {

    var statusLog: [IndicatorStates] = []
    var appearingStates: [IndicatorAppearingStates] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TestingLoadingIndicator: LoadingIndicator {
    func startLoading() {
        statusLog.append(.start)
    }
    
    func stopLoading() {
        statusLog.append(.stop)
    }
}
