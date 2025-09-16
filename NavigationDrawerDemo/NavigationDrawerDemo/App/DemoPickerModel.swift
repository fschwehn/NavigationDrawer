// FILE_HEADER

import SwiftUI

@Observable class DemoPickerModel {
    let demos: [Demo] = [
        .init(id: "one", name: "Demo 1", content: Demo1()),
        .init(id: "two", name: "Demo 2", content: Demo2()),
    ]

    var selection: Demo.ID

    init() {
        selection = demos.first?.id ?? ""
    }
}

extension EnvironmentValues {
    @Entry var demoPickerModel = DemoPickerModel()
}
