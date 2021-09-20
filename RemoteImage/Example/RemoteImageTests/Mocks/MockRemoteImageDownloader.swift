//
//  MockRemoteImageDownloader.swift
//  RemoteImage
//
//  Created by Aleksei Sergeev on 28.07.2021.
//

import UIKit
import RemoteImage
import XCTest

class MockRemoteImageDownloader: RemoteImageDownloader {

    var result: Result<DownloadedImageWithResponse, Error>?

    var accomplishedCompletion: ((Result<DownloadedImageWithResponse, Error>) -> Void)?

    func downloadImage(at url: URL, completion: @escaping (Result<DownloadedImageWithResponse, Error>) -> Void) -> URLSessionDataTask {
        accomplishedCompletion = completion
        return URLSessionDataTask()
    }

    func finishDownload() {
        if let result = result {
            accomplishedCompletion?(result)
            accomplishedCompletion = nil
        }
    }
}
