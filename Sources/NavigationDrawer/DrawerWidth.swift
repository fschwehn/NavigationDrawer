// FILE_HEADER

import SwiftUI

public enum DrawerWidth {
    case fixed(CGFloat)
    case relative(CGFloat)
    case inset(CGFloat)

    public static var `default`: Self { .fixed(320) }
}

extension DrawerWidth {
    func value(for geometry: GeometryProxy) -> CGFloat {
        switch self {
        case let .fixed(width):
            width
        case let .relative(fraction):
            geometry.size.width * fraction
        case let .inset(inset):
            geometry.size.width - inset
        }
    }
}
