// FILE_HEADER

import SwiftUI

struct DemoPicker: View {
    @Environment(\.demoPickerModel) private var model

    var selection: Binding<Demo.ID> {
        .init {
            model.selection
        } set: {
            model.selection = $0
        }
    }

    var body: some View {
        Picker("Demo", selection: selection) {
            ForEach(model.demos) { demo in
                Text(demo.name)
                    .id(demo.id)
            }
        }
    }
}

#Preview {
    DemoPicker()
}
