//
//  View+Extension.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation
import SwiftUI

extension Text {
    func apply(_ theFont: Font, _ color: Color? = nil, _ weight: Font.Weight? = nil) -> Text {
        var font = font(theFont)
        if let color = color {
           font = font.foregroundColor(color)
        }
        if let weight = weight {
           font = font.fontWeight(weight)
        }
        return font
    }
    
    func align(_ alignment: TextAlignment) -> some View {
        multilineTextAlignment(alignment)
    }
}


extension UIScreen {
    static func mainOrigin() -> CGPoint {
        main.origin
    }
    
    static func mainWidthScaled(_ scale: CGFloat) -> CGFloat {
        main.widthScaled(scale)
    }
    
    static func mainHeightScaled(_ scale: CGFloat) -> CGFloat {
        main.heightScaled(scale)
    }
    
    static var mainWidth: CGFloat {
        main.width
    }
    
    static var mainHeight: CGFloat {
        main.height
    }
    
    static var mainMidX: CGFloat {
        main.midX
    }
    
    static var mainMidY: CGFloat {
        main.midY
    }
    
    static var mainMinX: CGFloat {
        main.minX
    }
    
    static var mainMinY: CGFloat {
        main.minY
    }
    
    static var mainMaxX: CGFloat {
        main.maxX
    }
    
    static var mainMaxY: CGFloat {
        main.maxY
    }
    
    static var mainSize: CGSize {
        main.size
    }
    
    static var safeArea: UIEdgeInsets {
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets ?? .zero
    }
    
    func widthScaled(_ scale: CGFloat) -> CGFloat {
        width * scale
    }
    
    func heightScaled(_ scale: CGFloat) -> CGFloat {
        height * scale
    }
    
    var origin: CGPoint {
        bounds.origin
    }
    
    var width: CGFloat {
        bounds.width
    }
    
    var height: CGFloat {
        bounds.height
    }
    
    var size: CGSize {
        bounds.size
    }
    
    var midX: CGFloat {
        bounds.midX
    }
    
    var midY: CGFloat {
        bounds.midY
    }
    
    var minX: CGFloat {
        bounds.origin.x
    }
    
    var minY: CGFloat {
        bounds.origin.y
    }
    
    var maxX: CGFloat {
        bounds.maxX
    }
    
    var maxY: CGFloat {
        bounds.maxY
    }
    
    static func visibleViewController(baseVC: UIViewController? = nil) -> UIViewController? {
        let rootVC = baseVC ?? UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController
        
        if let nav = rootVC as? UINavigationController {
            return visibleViewController(baseVC: nav.visibleViewController)
        }
        if let tab = rootVC as? UITabBarController, let selected = tab.selectedViewController {
            return visibleViewController(baseVC: selected)
        }
        if let presented = rootVC?.presentedViewController {
            return visibleViewController(baseVC: presented)
        }
        return rootVC
    }
}
