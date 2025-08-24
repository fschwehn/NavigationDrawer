// FILE_HEADER

import SwiftUI

struct NavigationDrawerContent<Content: View, Drawer: View>: View {
    @Binding var isOpen: Bool

    var drawerWidth: CGFloat
    var drawer: () -> Drawer
    var content: () -> Content

    var body: some View {
        ZStack(alignment: .leading) {
            drawer()
                .frame(width: drawerWidth, alignment: .leading)
                .offset(x: isOpen ? 0 : -drawerWidth)
            content()
                .offset(x: isOpen ? drawerWidth : 0)
        }
        .animation(.default, value: isOpen)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
