// FILE_HEADER

import SwiftUI
import UIKit


extension View {
    public func removeBackground() -> some View {
        modifier(RemoveBackgroundModifier())
    }
}

private struct RemoveBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ClearBackgroundHost(content: content)
            .ignoresSafeArea()
    }
}

private struct ClearBackgroundHost<Content: View>: UIViewControllerRepresentable {
    let content: Content

    func makeUIViewController(context: Context) -> TransparentHostingController<Content> {
        let hosting = TransparentHostingController(rootView: content)
        hosting.view.backgroundColor = .clear
        hosting.view.isOpaque = false
        return hosting
    }

    func updateUIViewController(_ uiViewController: TransparentHostingController<Content>, context: Context) {
        uiViewController.rootView = content
    }
}

private final class TransparentHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidAppear(_ animated: Bool) {
        removeFirstBackground(from: view.subviews)

        super.viewDidAppear(animated)
    }

    func removeFirstBackground(from subviews: [UIView]) {
        for view in subviews {
            if view.backgroundColor != nil {
                view.backgroundColor = nil
                view.isOpaque = false
            } else {
                removeFirstBackground(from: view.subviews)
            }
        }
    }
}
