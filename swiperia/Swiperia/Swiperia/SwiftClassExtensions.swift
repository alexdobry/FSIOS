//
//  Extensions.swift
//  Swiperia
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

extension Double {
    var clearString: String {
        return String(format: "%.0f", self)
    }
}
