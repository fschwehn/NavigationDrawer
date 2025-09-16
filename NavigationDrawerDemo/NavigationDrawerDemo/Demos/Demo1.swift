// FILE_HEADER

import NavigationDrawer
import SwiftUI

struct Demo1: View {
    @State private var isDrawerOpen: Bool = false

    let drawerBackground = LinearGradient(
        colors: [.gray, .teal],
        startPoint: .top,
        endPoint: .bottom
    )

    let contentBackground = LinearGradient(
        colors: [.blue, .gray],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationDrawer(
            isOpen: $isDrawerOpen,
            drawerWidth: .inset(60)
        ) {
            DemoPicker()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 63)
                        .fill(drawerBackground)
                        .ignoresSafeArea()
                        .padding(.leading, -24)
                        .shadow(radius: 20)
                }
                .tint(.pink)
        } content: {
            Text("content")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Content")
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button {
                            isDrawerOpen.toggle()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
        }
        .tint(.orange)
        .background(contentBackground)
    }
}

#Preview {
    Demo1()
}
