//
//  MockRemoteImageCache.swift
//  RemoteImage
//
//  Created by Aleksei Sergeev on 28.07.2021.
//

import UIKit
import RemoteImage
import XCTest

class MockRemoteImageCache: RemoteImageCache {
    var image: UIImage? = nil
    var storage = UIImage()
    
    func store(image: UIImage, forURL url: URL, response: URLResponse?) {
        storage = image
    }
    
    func obtainImage(forURL url: URL) -> UIImage? {
        return image
    }
    
    
}
