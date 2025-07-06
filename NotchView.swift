import SwiftUI

struct NotchView: View {
    @StateObject var vm: NotchViewModel
    @State private var dropTargeting: Bool = false
    @State private var isHovering: Bool = false
    
    var notchSize: CGSize {
        switch vm.status {
        case .closed:
            let baseWidth = vm.deviceNotchRect.width - 4
            let baseHeight = vm.deviceNotchRect.height - 4
            return CGSize(
                width: max(0, baseWidth),
                height: max(0, baseHeight)
            )
        case .opened:
            return vm.notchOpenedSize
        case .popping:
            return CGSize(
                width: vm.deviceNotchRect.width,
                height: vm.deviceNotchRect.height + 4
            )
        }
    }
    
    var notchCornerRadius: CGFloat {
        switch vm.status {
        case .closed: return 10
        case .opened: return 24
        case .popping: return 12
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Drag detector background
                dragDetector
                
                // Main notch container
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        ZStack(alignment: .top) {
                            notch
                                .disabled(vm.status == .popping)
                                .opacity(vm.notchVisible ? 1 : 0.3)
                            
                            if vm.status == .opened {
                                expandedContent
                                    .transition(.asymmetric(
                                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                                        removal: .opacity.combined(with: .scale(scale: 0.95))
                                    ))
                            }
                        }
                        .frame(
                            width: notchSize.width + notchCornerRadius * 2,
                            height: notchSize.height
                        )
                        .zIndex(100)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: vm.status)
        .preferredColorScheme(.dark)
    }
    
    var notch: some View {
        Rectangle()
            .foregroundStyle(.black)
            .mask(notchBackgroundMask)
            .frame(
                width: notchSize.width + notchCornerRadius * 2,
                height: notchSize.height
            )
            .shadow(
                color: .black.opacity(vm.status == .opened ? 0.5 : 0.3),
                radius: vm.status == .opened ? 16 : 8,
                x: 0,
                y: vm.status == .opened ? 6 : 3
            )
            .overlay(
                notchBackgroundMask
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.1), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
    
    var notchBackgroundMask: some Shape {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: notchCornerRadius,
            bottomTrailingRadius: notchCornerRadius,
            topTrailingRadius: 0
        )
    }
    
    var expandedContent: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "macbook")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("TopNotch Core")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(Date(), style: .time)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .monospacedDigit()
                
                Button(action: { vm.notchClose() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, vm.spacing)
            
            // Content
            VStack(spacing: 12) {
                Text("Dynamic Island for macOS")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    InfoBadge(icon: "cpu", text: "Native")
                    InfoBadge(icon: "sparkles", text: "Smooth")
                    InfoBadge(icon: "lock.shield", text: "Secure")
                }
            }
            .padding(.horizontal, vm.spacing)
            
            Spacer()
        }
        .padding(.vertical, vm.spacing)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var dragDetector: some View {
        VStack {
            HStack {
                Spacer()
                
                Rectangle()
                    .fill(Color.black.opacity(0.001))
                    .contentShape(Rectangle())
                    .frame(
                        width: notchSize.width + vm.dropDetectorRange,
                        height: vm.status == .closed ? 
                            (notchSize.height + vm.dropDetectorRange) :
                            (vm.deviceNotchRect.height + vm.dropDetectorRange)
                    )
                    .onHover { hovering in
                        isHovering = hovering
                    }
                    .onTapGesture {
                        vm.toggleNotch()
                    }
                    .onDrop(of: [.data], isTargeted: $dropTargeting) { providers in
                        if vm.status == .closed {
                            vm.notchOpen(.drag)
                            vm.hapticSender.send()
                        }
                        return true
                    }
                    .onChange(of: dropTargeting) { isTargeted in
                        if !isTargeted && vm.status == .opened {
                            let mouseLocation = NSEvent.mouseLocation
                            if !vm.notchOpenedRect.insetBy(dx: vm.inset, dy: vm.inset).contains(mouseLocation) {
                                vm.notchClose()
                            }
                        }
                    }
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct InfoBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
            Text(text)
                .font(.system(size: 10, weight: .medium, design: .rounded))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.1))
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 0.5)
                )
        )
    }
}
