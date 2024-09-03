
import SwiftUI

struct FontCustomModifier: ViewModifier {
    let size: CGFloat
    let weight: UIFont.Weight
    let color: Color?
    var design: UIFontDescriptor.SystemDesign? = nil
    
    func body(content: Content) -> some View {
        content
            .font(Font(UIFont.fontWith(size: size, weight: weight, design: design)))
            .foregroundColorCustom(color != nil ? color! : Color.black)
    }
}

extension View {
    func fontCustom(size: CGFloat, weight: UIFont.Weight, color: Color? = nil, design: UIFontDescriptor.SystemDesign? = nil) -> some View {
        modifier(FontCustomModifier(size: size, weight: weight, color: color, design: design))
    }
}

import SwiftUI

struct ForegroundColorCustomModifier: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .foregroundStyle(color)
        } else {
            content
                .foregroundColor(color)
        }
    }
}

extension View {
    func foregroundColorCustom(_ color: Color) -> some View {
        modifier(ForegroundColorCustomModifier(color: color))
    }
}

extension UIFont {
    class func fontWith(size: CGFloat, weight: CGFloat, design: UIFontDescriptor.SystemDesign? = nil) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: .init(weight))
        if let design = design, let descriptor = systemFont.fontDescriptor.withDesign(design) {
            return UIFont(descriptor: descriptor, size: size)
        } else {
            return systemFont
        }
    }
    
    class func fontWith(size: CGFloat, weight: UIFont.Weight, design: UIFontDescriptor.SystemDesign? = nil) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        if let design = design, let descriptor = systemFont.fontDescriptor.withDesign(design) {
            return UIFont(descriptor: descriptor, size: size)
        } else {
            return systemFont
        }
    }
}

