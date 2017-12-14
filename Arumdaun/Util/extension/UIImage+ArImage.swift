//
//  UIImage+ArImage.swift
//  Arumdaun
//
//  Created by Park, Chanick on 7/13/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit

extension UIImage {
    // MARK: - image with color
    convenience init?(imageName: String) {
        self.init(named: imageName)!
        accessibilityIdentifier = imageName
    }
    
    // https://stackoverflow.com/a/40177870/4488252
    func imageWithColor (newColor: UIColor?) -> UIImage? {
        
        if let newColor = newColor {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            
            newColor.setFill()
            context.fill(rect)
        
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }
        
        if let accessibilityIdentifier = accessibilityIdentifier {
            return UIImage(imageName: accessibilityIdentifier)
        }
        
        return self
    }
    
    static func multiplyImageByConstantColor(image:UIImage,color:UIColor) -> UIImage {
        
        let backgroundSize = image.size
        UIGraphicsBeginImageContext(backgroundSize)
        
        guard let ctx = UIGraphicsGetCurrentContext() else {return image}
        
        var backgroundRect=CGRect()
        backgroundRect.size = backgroundSize
        backgroundRect.origin.x = 0
        backgroundRect.origin.y = 0
        
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        ctx.setFillColor(red: r, green: g, blue: b, alpha: a)
        
        // Unflip the image
        ctx.translateBy(x: 0, y: backgroundSize.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.clip(to: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), mask: image.cgImage!)
        ctx.fill(backgroundRect)
        
        
        var imageRect=CGRect()
        imageRect.size = image.size
        imageRect.origin.x = (backgroundSize.width - image.size.width)/2
        imageRect.origin.y = (backgroundSize.height - image.size.height)/2
        
        
        ctx.setBlendMode(.multiply)
        ctx.draw(image.cgImage!, in: imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImage {
    // MARK: - resizing, crop
    /// image crop from center
    func cropedToScale(scaleTo: CGFloat) -> UIImage? {
        let newImageWidth = size.width * scaleTo
        let newImageHeight = size.height * scaleTo
        
        let cropRect = CGRect(x: (size.width - newImageWidth) / 2,
                              y: (size.height - newImageHeight) / 2,
                              width: newImageWidth,
                              height: newImageHeight)
        
        guard let cgImage = cgImage else {
            return nil
        }
        guard let newCgImage = cgImage.cropping(to: cropRect) else {
            return nil
        }
        
        return UIImage(cgImage: newCgImage, scale: scale, orientation: imageOrientation)
    }
    
    /// ratio: (height/width)
    func cropedToRatio(ratio: CGFloat) -> UIImage? {
        let newImgHeight = min(size.width * ratio, size.height)
        let newImgWidth = newImgHeight * (1/ratio)
        
        let cropRect = CGRect(x: (size.width - newImgWidth) / 2,
                              y: (size.height - newImgHeight) / 2,
                              width: newImgWidth,
                              height: newImgHeight)
        
        guard let cgImage = cgImage else {
            return nil
        }
        guard let newCgImage = cgImage.cropping(to: cropRect) else {
            return nil
        }
        
        return UIImage(cgImage: newCgImage, scale: scale, orientation: imageOrientation)
    }
}

