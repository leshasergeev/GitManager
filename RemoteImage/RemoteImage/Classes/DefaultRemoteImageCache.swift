//
//  DefaultRemoteImageCache.swift
//  RemoteImage
//
//  Created by Aleksei Sergeev on 23.07.2021.
//

import UIKit

public protocol RemoteImageCache {
    func store(image: UIImage, forURL url: URL, response: URLResponse?)
    func obtainImage(forURL url: URL) -> UIImage?
}

class DefaultRemoteImageCache: RemoteImageCache {
    
    private(set) var cache = URLCache()
    
    func store(image: UIImage, forURL url: URL, response: URLResponse?) {
        let urlRequest = URLRequest(url: url)
        if let data = UIImagePNGRepresentation(image) {
            let resp = response ?? URLResponse(url: url,
                                               mimeType: nil,
                                               expectedContentLength: data.count,
                                               textEncodingName: nil)
            let cachedURLResponse = CachedURLResponse( response: resp, data: data)
            cache.storeCachedResponse(cachedURLResponse, for: urlRequest)
        }
    }
    
    func obtainImage(forURL url: URL) -> UIImage? {
        let cachedUrlResponse = cache.cachedResponse(for: URLRequest(url: url))
        if let data = cachedUrlResponse?.data, let image = UIImage(data: data) {
            return image
        }
        return nil
    }
}
