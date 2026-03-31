import AppKit
import SwiftUI

@main
struct RayTracerApp: App {
    init() {
        // When launched via `swift run` (no .app bundle), macOS defaults to
        // a background activation policy — no Dock icon and the window can't
        // hold focus.  Force regular-app behaviour explicitly.
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)
    }
}
