//
//  UIImageView+RemoteImage.swift
//  Nimble
//
//  Created by Aleksei Sergeev on 19.07.2021.
//

import UIKit

public protocol LoadingIndicator {
    func startLoading()
    func stopLoading()
}

public typealias LoadingIndicatorView = UIView & LoadingIndicator

private var imageViewStoredTaskKey: Void?

public extension UIImageView {
    
    func setImage(with url: URL?,
                  placeholder: UIImage? = nil,
                  loadingIndicator: LoadingIndicatorView? = nil,
                  imageProcessor: ImageProcessor? = nil,
                  completion: (() -> ())? = nil) {
        guard let url = url else {
            if let placeholder = placeholder { self.image = placeholder }
            return
        }
        
        subviews
            .compactMap { $0 as? LoadingIndicatorView }
            .filter { $0 !== loadingIndicator }
            .forEach { $0.removeFromSuperview() }
        
        if let loadingIndicator = loadingIndicator,
           loadingIndicator.superview != self {
            addSubview(loadingIndicator)
            setConstraintsForLoadingIndicator(loadingIndicator)
        }
        
        storedTask?.cancel()
        
        let urlForCache = createURLForCache(withURL: url, andImageProcessor: imageProcessor)
        
        if let image = RemoteImageTools.shared.imageCache.obtainImage(forURL: urlForCache) {
            self.image = image
        } else {
            storedTask = RemoteImageTools.shared.imageDownloader.downloadImage(at: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(downloadedImageWithResponse):
                        let image       = downloadedImageWithResponse.image
                        let response    = downloadedImageWithResponse.response
                        self.storedTask = nil
                        let proccesedImage = imageProcessor?.process(image: image) ?? image
                        self.image = proccesedImage
                        loadingIndicator?.stopLoading()
                        loadingIndicator?.removeFromSuperview()
                        DispatchQueue.global(qos: .userInitiated).async {
                            RemoteImageTools.shared.imageCache.store(image: proccesedImage,
                                                                     forURL: urlForCache,
                                                                     response: response)
                        }
                    case .failure(_):
                        if let placeholder = placeholder { self.image = placeholder }
                        loadingIndicator?.stopLoading()
                        loadingIndicator?.removeFromSuperview()
                    }
                    completion?()
                }
            }
            loadingIndicator?.startLoading()
        }
    }
    
    private func setConstraintsForLoadingIndicator(_ loadingIndicator: LoadingIndicatorView) {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: self.topAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func createURLForCache(withURL url: URL, andImageProcessor imageProcessor: ImageProcessor?) -> URL {
        var urlForCache = url
        if let imgProcIdentifier = imageProcessor?.identifier {
            urlForCache.appendPathComponent(imgProcIdentifier)
        }
        
        return urlForCache
    }
}

extension UIImageView {
    public var storedTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &imageViewStoredTaskKey) as? URLSessionDataTask ?? nil
        }
        set {
            if newValue == nil {
                objc_removeAssociatedObjects(self.storedTask!)
            }
            objc_setAssociatedObject(self, &imageViewStoredTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
