//
//  DefaultRemoteImageDownloader.swift
//  RemoteImage
//
//  Created by Aleksei Sergeev on 23.07.2021.
//

import UIKit

public protocol RemoteImageDownloader {
    func downloadImage(at url: URL,
                       completion: @escaping (Result<DownloadedImageWithResponse, Error>) -> Void) -> URLSessionDataTask
}

public class DownloadedImageWithResponse {
    private(set) var image: UIImage
    private(set) var response: URLResponse

    public init(image: UIImage, response: URLResponse) {
        self.image      = image
        self.response   = response
    }
}

class DefaultRemoteImageDownloader: RemoteImageDownloader {

    private var urlSession: URLSession {
        let defaultSessConfig = URLSessionConfiguration.default

        defaultSessConfig.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        defaultSessConfig.timeoutIntervalForRequest = 30
        defaultSessConfig.urlCache = nil

        return URLSession(configuration: defaultSessConfig)
    }

    typealias DownloadImageHandler = (Result<DownloadedImageWithResponse, Error>) -> Void

    func downloadImage(at url: URL, completion: @escaping DownloadImageHandler) -> URLSessionDataTask {
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let image = UIImage(data: data),
                      let response = response {
                let downloadedImageWithResponse = DownloadedImageWithResponse(image: image, response: response)
                completion(.success(downloadedImageWithResponse))
            }
        }
        task.resume()
        return task
    }
}
