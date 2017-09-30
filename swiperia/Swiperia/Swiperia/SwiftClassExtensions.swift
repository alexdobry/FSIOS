//
//  Extensions.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 16.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SpriteKit

struct ColorComponents {
    var r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat
}

extension UIColor {
    
    func getComponents() -> ColorComponents {
        if (self.cgColor.numberOfComponents == 2) {
            let cc = self.cgColor.components;
            return ColorComponents(r:cc![0], g:cc![0], b:cc![0], a:cc![1])
        }
        else {
            let cc = self.cgColor.components;
            return ColorComponents(r:cc![0], g:cc![1], b:cc![2], a:cc![3])
        }
    }
    
    func interpolateRGBColorTo(end: UIColor, fraction: CGFloat) -> UIColor {
        var f = max(0, fraction)
        f = min(1, fraction)
        
        let c1 = self.getComponents()
        let c2 = end.getComponents()
        
        let r = c1.r + (c2.r - c1.r) * f
        let g = c1.g + (c2.g - c1.g) * f
        let b = c1.b + (c2.b - c1.b) * f
        let a = c1.a + (c2.a - c1.a) * f
        
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
}


protocol Fignable {
    init()
    static func <(lhs:Self, rhs:Self) -> Bool
}

extension Fignable {
    func fign() -> Int {
        return (self < Self() ? -1 : 1)
    }
}

/* extend signed integer types to Signable */
extension Int: Fignable { }    // already have < and init() functions, OK
extension Int8 : Fignable { }  // ...
extension Int16 : Fignable { }
extension Int32 : Fignable { }
extension Int64 : Fignable { }

/* extend floating point types to Signable */
extension Double : Fignable { }
extension Float : Fignable { }
extension CGFloat : Fignable { }


///
extension Dictionary {
    func randomItem() -> Value {
        let index: Int = Int(arc4random_uniform(UInt32(self.count)))
        return Array(self.values)[index]
    }
}

///
extension Array {
    func randomItem() -> Element {
        let index: Int = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

///
extension CIImage {
    func convertToUI() -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(self, from: self.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}

///
extension Double {
    var clearString: String {
        return String(format: "%.0f", self)
    }
    
    func shorten(to decimalNumbers: Double) -> Double {
        if decimalNumbers != 0 {
            let shortenAmount = pow(10, decimalNumbers)
            return (self * shortenAmount).rounded() / shortenAmount
        } else {
            let number = self
            return Darwin.round(number)
        }
    }
}

extension UIImage {
    func areaAverage() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        if #available(iOS 9.0, *) {
            // Get average color.
            let context = CIContext()
            let inputImage: CIImage = ciImage ?? CoreImage.CIImage(cgImage: cgImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGContext(data: &bitmap, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            let inputImage = cgImage ?? CIContext().createCGImage(ciImage!, from: ciImage!.extent)
            
            // Render to bitmap.
            context.draw(inputImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
}

extension UITabBarController {
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
            self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
            }.startAnimation()
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}
