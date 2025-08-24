// FILE_HEADER

import SwiftUI

public enum DrawerWidth {
    case fixed(CGFloat)

    public static var `default`: Self { .fixed(320) }
}

extension DrawerWidth {
    func value(for geometry: GeometryProxy) -> CGFloat {
        switch self {
        case let .fixed(value):
            value
        }
    }
}
