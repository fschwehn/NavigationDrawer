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

#Preview {
    @Previewable @State var isDrawerOpen = false

    NavigationDrawer(
        isOpen: $isDrawerOpen,
        drawerWidth: .fixed(320)
    ) {
        Text("Drawer")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.gray, .red],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(0.75)
            )
    } content: {
        NavigationStack {
            Text("Content")
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
