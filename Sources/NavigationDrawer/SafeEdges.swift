// FILE_HEADER

import SwiftUI

struct SafeEdges: View {
    var progress: CGFloat = 0

    var body: some View {
        GeometryReader { g in
            let inset = g.safeAreaInsets.leading
            let contentWidth = g.size.width + g.safeAreaInsets.trailing
            let fullWidth = inset + contentWidth
            let backgroundPadding = min(0, progress * fullWidth - inset)
            let contentOffset = max(0, progress * fullWidth - inset)

            NavigationStack {
                VStack {
                    Text("Leading")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Trailing")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .monospacedDigit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.teal.opacity(0.5)
                        .ignoresSafeArea(edges: [.vertical, .trailing])
                        .padding(.leading, backgroundPadding)
                )
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Text("navigation")
                    }
                    ToolbarItem(placement: .principal) {
                        Text("principal")
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Text("primaryAction")
                    }
                }
            }
            .frame(width: contentWidth)
            .offset(x: contentOffset)
        }
    }
}

#Preview("animated", traits: .landscapeLeft) {
    TimelineView(.animation) { schedule in
        let duration = 3.0
        let progress = schedule.date.timeIntervalSince1970.truncatingRemainder(dividingBy: duration) / duration
        SafeEdges(progress: progress / 3)
    }
}

#Preview("manual", traits: .landscapeLeft) {
    SafeEdges(progress: 0)
}
