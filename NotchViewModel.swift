import SwiftUI
import Combine

@MainActor
class NotchViewModel: ObservableObject {
    // MARK: - Notch States
    enum NotchStatus: String, CaseIterable {
        case closed
        case opened
        case popping
    }
    
    enum OpenReason: String, CaseIterable {
        case click
        case drag
        case boot
        case unknown
    }
    
    // MARK: - Published Properties
    @Published var status: NotchStatus = .closed
    @Published var openReason: OpenReason = .unknown
    @Published var notchVisible: Bool = true
    
    // MARK: - Geometry Properties
    let notchOpenedSize: CGSize = .init(width: 500, height: 120)
    let dropDetectorRange: CGFloat = 32
    let inset: CGFloat = -4
    let spacing: CGFloat = 16
    let cornerRadius: CGFloat = 16
    
    // Device notch properties
    var deviceNotchRect: CGRect {
        // Approximate MacBook notch size
        let notchWidth: CGFloat = 160
        let notchHeight: CGFloat = 30
        
        if let screen = NSScreen.main {
            let screenWidth = screen.frame.width
            return CGRect(
                x: (screenWidth - notchWidth) / 2,
                y: screen.frame.height - notchHeight,
                width: notchWidth,
                height: notchHeight
            )
        }
        
        return CGRect(x: 0, y: 0, width: notchWidth, height: notchHeight)
    }
    
    var screenRect: CGRect {
        NSScreen.main?.frame ?? .zero
    }
    
    var notchOpenedRect: CGRect {
        .init(
            x: screenRect.origin.x + (screenRect.width - notchOpenedSize.width) / 2,
            y: screenRect.origin.y + screenRect.height - notchOpenedSize.height,
            width: notchOpenedSize.width,
            height: notchOpenedSize.height
        )
    }
    
    // MARK: - Animation
    let animation: Animation = .interactiveSpring(
        duration: 0.5,
        extraBounce: 0.0,
        blendDuration: 0.125
    )
    
    // MARK: - Haptic Feedback
    let hapticSender = PassthroughSubject<Void, Never>()
    
    // MARK: - Methods
    func notchOpen(_ reason: OpenReason) {
        openReason = reason
        status = .opened
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func notchClose() {
        status = .closed
        openReason = .unknown
    }
    
    func toggleNotch() {
        if status == .closed {
            notchOpen(.click)
        } else {
            notchClose()
        }
        hapticSender.send()
    }
}
