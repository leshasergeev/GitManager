//
//  RIDownloaderTests.swift
//  RemoteImageTests
//
//  Created by Aleksei Sergeev on 28.07.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import RemoteImage

class RemoteImageDownloaderTests: XCTestCase {
    
    var systemUnderTest: DefaultRemoteImageDownloader!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        systemUnderTest = DefaultRemoteImageDownloader()
    }

    override func tearDownWithError() throws {
        systemUnderTest = nil
        try super.tearDownWithError()
    }
    
    func testDataTasksURLWhenItIsProvided() throws {
        let url = try XCTUnwrap(URL(string: "https://i.ytimg.com/vi/1Ne1hqOXKKI/maxresdefault.jpg"))
        
        //when
        let dataTaskFromSUT = systemUnderTest.downloadImage(at: url) { _ in}
        
        //then
        XCTAssertEqual(dataTaskFromSUT.currentRequest?.url, url)
    }

}
