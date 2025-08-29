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

    var body: some View {
        ZStack(alignment: .leading) {
            drawer()
                .frame(width: drawerWidth, alignment: .leading)
                .offset(x: drawerOffset)
            content()
                .offset(x: contentOffset)
        }
        .animation(
            .interpolatingSpring(duration: 0.36, bounce: 0.15, initialVelocity: 14),
            value: [isOpen, dragState.isDragging])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(swipeGesture)
    }

    var drawerOffset: CGFloat {
        let rawOffset = (isOpen ? 0 : -drawerWidth) + dragState.delta
        return rubberBandOffset(for: rawOffset, minOffset: -drawerWidth, maxOffset: 0)
    }

    var contentOffset: CGFloat {
        let rawOffset = (isOpen ? drawerWidth : 0) + dragState.delta
        return rubberBandOffset(for: rawOffset, minOffset: 0, maxOffset: drawerWidth)
    }

    func clippedOffset(for rawOffset: CGFloat, minOffset: CGFloat, maxOffset: CGFloat) -> CGFloat {
        max(minOffset, min(rawOffset, maxOffset))
    }

    func rubberBandOffset(for rawOffset: CGFloat, minOffset: CGFloat, maxOffset: CGFloat) -> CGFloat {
        if rawOffset < minOffset {
            return softClip(rawOffset: rawOffset, threshold: minOffset)
        } else if rawOffset > maxOffset {
            return softClip(rawOffset: rawOffset, threshold: maxOffset)
        } else {
            return rawOffset
        }
    }

    func softClip(rawOffset: CGFloat, threshold: CGFloat) -> CGFloat {
        let stiffness: CGFloat = 5
        let overshoot = (rawOffset - threshold)
        let overshootFraction = overshoot / drawerWidth
        let factor = 1 / (1 + abs(overshootFraction) * stiffness)
        return threshold + overshoot * factor
    }

    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                lockSwipeGestureAxis(value: value)

                guard dragState.isDragging else { return }

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
