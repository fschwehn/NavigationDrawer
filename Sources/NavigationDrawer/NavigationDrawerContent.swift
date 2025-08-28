// FILE_HEADER

import SwiftUI

struct NavigationDrawerContent<Content: View, Drawer: View>: View {
    @Binding var isOpen: Bool

    var drawerWidth: CGFloat
    var drawer: () -> Drawer
    var content: () -> Content

    private struct DragState {
        var lockedAxis: Axis? = nil
        var delta: CGFloat = 0
        var isDragging: Bool { lockedAxis == .horizontal }
    }

    @Environment(\.layoutDirection) private var layoutDirection

    @State private var dragState = DragState()

    // TODO: support right to left
    var drawerOffset: CGFloat { (isOpen ? 0 : -drawerWidth) + dragState.delta }
    var contentOffset: CGFloat { (isOpen ? drawerWidth : 0) + dragState.delta }

    var body: some View {
        ZStack(alignment: .leading) {
            drawer()
                .frame(width: drawerWidth, alignment: .leading)
                .offset(x: drawerOffset)
            content()
                .offset(x: contentOffset)
        }
        .animation(.snappy, value: [isOpen, dragState.isDragging])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(swipeGesture)
    }

    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                lockSwipeGestureAxis(value: value)

                guard dragState.isDragging else { return }

                // TODO: different clamping behaviours (clip, rubber band)
                dragState.delta = value.translation.width

                if layoutDirection == .rightToLeft {
                    dragState.delta.negate()
                }
            }
            .onEnded { value in
                defer { dragState = .init() }

                guard dragState.isDragging else { return }

                let progress = max(-1, min(1, (dragState.delta / drawerWidth)))

                // TODO: parameterize open / close threshold(s)
                if isOpen {
                    isOpen = progress > -0.5
                } else {
                    isOpen = progress > 0.5
                }
            }
    }

    func lockSwipeGestureAxis(value: DragGesture.Value) {
        if dragState.lockedAxis == nil {
            let absDx = abs(value.translation.width)
            let absDy = abs(value.translation.height)

            dragState.lockedAxis = absDx > absDy ? .horizontal : .vertical
        }
    }
}
