// FILE_HEADER

import SwiftUI

struct ContentView: View {
    let demoPickerModel = DemoPickerModel()

    var demo: Demo? {
        demoPickerModel.demos.first { $0.id == demoPickerModel.selection }
    }

    var body: some View {
        if let demo {
            demo.content()
                .environment(\.demoPickerModel, demoPickerModel)
                .animation(.default, value: demoPickerModel.selection)
        }
    }
}

#Preview {
    ContentView()
}
