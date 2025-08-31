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
            NavigationDrawerContent(
                isOpen: $isOpen,
                drawerWidth: drawerWidth.value(for: geometry),
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
            .background(
                LinearGradient(
                    colors: [.gray, .red],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(0.75)
            )
    }
}

private struct DemoContent: View {
    @Binding var isDrawerOpen: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text("Content")
                    .font(.title)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.teal, .gray,],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(0.75)
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isDrawerOpen.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
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

#Preview("portait open", traits: .portrait) {
    @Previewable @State var isDrawerOpen = true

    NavigationDrawer(
        isOpen: $isDrawerOpen,
        drawerWidth: .fixed(320),
        drawer: { DemoDrawer() },
        content: { DemoContent(isDrawerOpen: $isDrawerOpen) }
    )
}

#Preview("relative width") {
    @Previewable @State var isDrawerOpen = false

    NavigationDrawer(
        isOpen: $isDrawerOpen,
        drawerWidth: .relative(0.8),
        drawer: { DemoDrawer() },
        content: { DemoContent(isDrawerOpen: $isDrawerOpen) }
    )
}

#Preview("inset width") {
    @Previewable @State var isDrawerOpen = true

    NavigationDrawer(
        isOpen: $isDrawerOpen,
        drawerWidth: .inset(80),
        drawer: { DemoDrawer() },
        content: { DemoContent(isDrawerOpen: $isDrawerOpen) }
    )
}
