//
//  GeneralRemoteImageTest.swift
//  RemoteImageTests
//
//  Created by Aleksei Sergeev on 29.07.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import RemoteImage

class GeneralRemoteImageTest: XCTestCase {
    
    var systemUnderTest: UIImageView!
    var remoteImageDownloaderMock: MockRemoteImageDownloader!
    var remoteImageCacheMock: MockRemoteImageCache!
    
    enum TestingErrors: Error {
        case test1, test2
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        systemUnderTest = UIImageView()
        remoteImageDownloaderMock = MockRemoteImageDownloader()
        remoteImageCacheMock = MockRemoteImageCache()
    }

    override func tearDownWithError() throws {
        systemUnderTest = nil
        remoteImageDownloaderMock = nil
        remoteImageCacheMock = nil
        try super.tearDownWithError()
    }
    
    // MARK: - URL's Tests
    func testNullInsteadOfImageIfNilURLProvided() {
        let url: URL? = nil
        
        // when
        systemUnderTest.setImage(with: url)
        
        //then
        XCTAssertTrue(systemUnderTest.image == nil)
    }
    
    // MARK: - Image's Tests
    func testDownloadedImageEqualToRetrievedDataFromDownloader() throws {
        let url = URL(string: "https://i.ytimg.com/vi/1Ne1hqOXKKI/maxresdefault.jpg")
        let image = UIImage(color: .white, size: CGSize(width: 100, height: 100))!
        
        let expectation = XCTestExpectation(description: "LoadingIndicator Stops")
        
        remoteImageDownloaderMock.result = .success(DownloadedImageWithResponse(image: image, response: URLResponse()))
        RemoteImageTools.shared.imageDownloader = remoteImageDownloaderMock
        
        remoteImageCacheMock.image = nil
        RemoteImageTools.shared.imageCache = remoteImageCacheMock
        
        // when
        systemUnderTest.setImage(with: url) {
            expectation.fulfill()
        }
        remoteImageDownloaderMock.finishDownload()
        
        //then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(self.systemUnderTest.image?.pngData() == image.pngData())
    }
    
    // MARK: - Placeholder's Tests
    func testNullInsteadOfImageIfBadURLProvided() {
        let url = URL(string: "")
        
        // when
        systemUnderTest.setImage(with: url)
        
        //then
        XCTAssertTrue(systemUnderTest.image == nil)
    }
    
    func testDisplayingPlaceholderOnBadUrlProvided() {
        let url = URL(string: "")
        let placeholder = UIImage(systemName: "photo.fill.on.rectangle.fill")
        
        // when
        systemUnderTest.setImage(with: url, placeholder: placeholder)
        
        //then
        XCTAssertTrue(systemUnderTest.image === placeholder)
    }
    
    // MARK: - Loading Indicator's Tests
    
    func testLoadIndicToStartAndStopWhenBadURLProvided() {
        let url = URL(string: "https://google.com")
        let loadingIndicator = TestingLoadingIndicator()
        
        let expectation = XCTestExpectation(description: "LoadingIndicator Stops")
        
        remoteImageDownloaderMock.result = .failure(TestingErrors.test1)
        RemoteImageTools.shared.imageDownloader = remoteImageDownloaderMock
        
        remoteImageCacheMock.image = nil
        RemoteImageTools.shared.imageCache = remoteImageCacheMock
        
        // when
        systemUnderTest.setImage(with: url, loadingIndicator: loadingIndicator, completion: {
            expectation.fulfill()
        })
        remoteImageDownloaderMock.finishDownload()
        
        //then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(loadingIndicator.statusLog, [.start, .stop])
    }
    
    func testIndicatorAppearsAndDisappearsIfUrlIsProvided() {
        let url = URL(string: "https://i.ytimg.com/vi/1Ne1hqOXKKI/maxresdefault.jpg")
        let loadingIndicator = TestingLoadingIndicator()
        
        let expectationOfAppearing = XCTestExpectation(description: "LoadingIndicator Disappears")
        
        remoteImageDownloaderMock.result = .failure(TestingErrors.test1)
        RemoteImageTools.shared.imageDownloader = remoteImageDownloaderMock
        
        remoteImageCacheMock.image          = nil
        RemoteImageTools.shared.imageCache  = remoteImageCacheMock
        
        // when
        systemUnderTest.setImage(with: url, loadingIndicator: loadingIndicator) {
            expectationOfAppearing.fulfill()
        }
        
        // then
        XCTAssertTrue(loadingIndicator.superview === systemUnderTest)
        remoteImageDownloaderMock.finishDownload()
        wait(for: [expectationOfAppearing], timeout: 2.0)
        XCTAssertTrue(loadingIndicator.superview == nil)
    }
}
