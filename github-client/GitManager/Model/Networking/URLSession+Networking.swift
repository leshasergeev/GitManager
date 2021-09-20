//
//  URLSession+Networking.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 18.08.2021.
//

import Foundation

protocol Networking {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Networking {}
