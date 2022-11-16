//
//  FontProvider.swift
//  RedditMemes
//

import Foundation
import SwiftUI

enum FractionalFont {
    case black, bold, extrabold, extralight, light, medium, regular, semibold, thin
}

extension FractionalFont {
    func size(_ size: CGFloat) -> Font {
        switch self {
        case .black:
            return Font.custom("Inter-Black", size: size)
        case .bold:
            return Font.custom("Inter-Bold", size: size)
        case .extrabold:
            return Font.custom("Inter-ExtraBold", size: size)
        case .extralight:
            return Font.custom("Inter-ExtraLight", size: size)
        case .light:
            return Font.custom("Inter-Light", size: size)
        case .medium:
            return Font.custom("Inter-Medium", size: size)
        case .regular:
            return Font.custom("Inter-Regular", size: size)
        case .semibold:
            return Font.custom("Inter-SemiBold", size: size)
        case .thin:
            return Font.custom("Inter-thin", size: size)
        }
    }
}
