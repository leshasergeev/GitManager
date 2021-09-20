//
//  RICacheTests.swift
//  RemoteImageTests
//
//  Created by Aleksei Sergeev on 28.07.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import RemoteImage

class RemoteImageCacheTests: XCTestCase {

    var sut: DefaultRemoteImageCache!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DefaultRemoteImageCache()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testImageShouldBeSameWhenObtainFromCache() throws {
        let image       = try XCTUnwrap( UIImage(color: .white, size: CGSize(width: 100, height: 100)) )
        let url         = try XCTUnwrap( URL(string: "https://i.ytimg.com/vi/1Ne1hqOXKKI/maxresdefault.jpg") )

        // when
        sut.store(image: image, forURL: url, response: nil)
        let imageFromCache = try XCTUnwrap(sut.obtainImage(forURL: url))

        // then
        XCTAssertTrue(imageFromCache.pngData() == image.pngData())
    }

    func testNullInsteadOfImageWhenCacheHasNotImageForURL() throws {
        let url = try XCTUnwrap( URL(string: "https://kartinka.net/sampridumal.jpg") )

        // when
        let imageFromCache = sut.obtainImage(forURL: url)

        // then
        XCTAssertTrue(imageFromCache == nil)
    }
}
