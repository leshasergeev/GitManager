//
//  RoundedCornerImageProcessor.swift
//  RemoteImage
//
//  Created by Aleksei Sergeev on 23.07.2021.
//

import UIKit

public protocol ImageProcessor{
    var identifier: String { get }
    func process(image: UIImage) -> UIImage?
}

public class RoundCornerImageProcessor: ImageProcessor {
    public var identifier: String {
        "RoundCornerImageProcessor_w-\(targetRect.width)_h-\(targetRect.height)_cR-\(cornerRadius)_v\(Self.version)"
    }
    
    private static let version: Int = 1
    
    private var targetRect: CGRect
    
    private var cornerRadius: CGFloat
    
    public func process(image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 0)
        UIGraphicsGetImageFromCurrentImageContext()
        defer {
            UIGraphicsEndImageContext()
        }
        UIBezierPath(roundedRect: targetRect, cornerRadius: cornerRadius).addClip()
        image.draw(in: targetRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public init(targetSize: CGSize, cornerRadius: CGFloat) {
        self.targetRect     = CGRect(origin: .zero, size: targetSize)
        self.cornerRadius   = cornerRadius
    }
}
