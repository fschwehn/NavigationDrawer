// FILE_HEADER

import SwiftUI

public struct NavigationDrawer<Content: View, Drawer: View>: View {
    @Binding private var isOpen: Bool

    private let drawerWidth: DrawerWidth
    private let content: () -> Content
    private let drawer: () -> Drawer

    public init(
        isOpen: Binding<Bool>,
        drawerWidth: DrawerWidth = .default,
        @ViewBuilder drawer: @escaping () -> Drawer,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isOpen = isOpen
        self.drawerWidth = drawerWidth
        self.content = content
        self.drawer = drawer
    }

    public var body: some View {
        GeometryReader { geometry in
            InnerNavigationDrawer(
                isOpen: $isOpen,
                drawerWidth: drawerWidth.value(for: geometry),
                geometry: geometry,
                drawer: drawer,
                content: content
            )
        }
    }
}

private struct DemoDrawer: View {
    var body: some View {
        Text("Drawer")
            .font(.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.tertiary)
    }
}

private struct DemoContent: View {
    @Binding var isDrawerOpen: Bool

    var body: some View {
        Text("Content")
            .font(.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.secondary)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isDrawerOpen.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                    .tint(.orange)
                }
            }
    }
}

#Preview("auto") {
    @Previewable @State var isDrawerOpen = false

    NavigationDrawer(
        isOpen: $isDrawerOpen,
        drawerWidth: .fixed(320),
        drawer: { DemoDrawer() },
        content: { DemoContent(isDrawerOpen: $isDrawerOpen) }
    )
    .task {
        while !Task.isCancelled {
            try? await Task.sleep(for: .seconds(2))
            isDrawerOpen.toggle()
        }
    }
}

#Preview("manual", traits: .portrait) {
    @Previewable @State var isDrawerOpen = false

    NavigationDrawer(
        isOpen: $isDrawerOpen,
        drawerWidth: .fixed(320),
        drawer: { DemoDrawer() },
        content: { DemoContent(isDrawerOpen: $isDrawerOpen) }
    )
}
