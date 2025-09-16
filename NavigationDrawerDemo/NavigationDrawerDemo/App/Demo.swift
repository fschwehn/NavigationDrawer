// FILE_HEADER

import SwiftUI

struct Demo: Identifiable {
    let id: String
    let name: String

    var content: () -> AnyView

    init<Content: View>(id: String, name: String, content: @autoclosure @escaping () -> Content) {
        self.id = id
        self.content = { AnyView(content()) }
        self.name = name
    }
}
