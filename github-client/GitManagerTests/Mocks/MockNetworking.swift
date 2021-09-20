//
//  MockNetworking.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 19.08.2021.
//

import Foundation
@testable import GitManager

class MockNetworking: Networking {

    var result: Result<Data, Error>?

    var сompletion: ((Data?, URLResponse?, Error?) -> Void)?

    var request: URLRequest?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request

        self.сompletion = completionHandler
        // swiftlint:disable force_unwrapping
        return URLSession.shared.dataTask(with: URL(string: "https://google.com")!) { _, _, _ in }
    }

    func finishDownload() {
        if let result = result {
            switch result {
            case .success(let data):
                сompletion?(data, nil, nil)
                сompletion = nil
            case .failure(let error):
                сompletion?(nil, nil, error)
                сompletion = nil
            }
        }
    }
}
