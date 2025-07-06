import Cocoa
import SwiftUI

class NotchWindowController: NSWindowController {
    private var notchViewModel: NotchViewModel!
    
    convenience init() {
        let window = NotchWindow()
        self.init(window: window)
        
        notchViewModel = NotchViewModel()
        
        let contentView = NotchView(vm: self.notchViewModel)
            .ignoresSafeArea()
        
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
}

class NotchWindow: NSWindow {
    override init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(
            contentRect: .zero,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        setupWindow()
    }
    
    private func setupWindow() {
        // Window configuration
        isOpaque = false
        backgroundColor = .clear
        level = .screenSaver + 1
        collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        isMovableByWindowBackground = false
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        hasShadow = false
        
        // Position at top of screen
        if let screen = NSScreen.main {
            let screenFrame = screen.frame
            let windowFrame = NSRect(
                x: screenFrame.origin.x,
                y: screenFrame.origin.y + screenFrame.height - 100,
                width: screenFrame.width,
                height: 100
            )
            setFrame(windowFrame, display: true)
        }
    }
    
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}
