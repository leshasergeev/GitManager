//
//  RemoteImageTools.swift
//  RemoteImage
//
//  Created by Aleksei Sergeev on 26.07.2021.
//

import Foundation

class RemoteImageTools {

    static let shared = RemoteImageTools()

    private init() {}

    var imageDownloader: RemoteImageDownloader = DefaultRemoteImageDownloader()

    var imageCache: RemoteImageCache = DefaultRemoteImageCache()
}
