import SwiftUI
import PencilKit
import AVFoundation

struct WordTracingView: View {
    let letter: LipiLetter
    let onCorrect: () -> Void
    
    @State private var canvasView = PKCanvasView()
    @State private var feedbackMessage: String = "Trace the word above"
    @State private var isProcessing = false
    @State private var showSuccess = false
    @State private var showOutline = true
    @State private var wordScale: CGFloat = 1.0
    @State private var penWidth: CGFloat = 6
    @State private var pencilPosition: CGPoint = .zero
    @State private var isPencilDragging = false
    @State private var isPencilOnTrack = false
    @State private var outlineMask: OutlineMask?
    @State private var didSetInitialPencil = false
    @State private var pencilStrokePoints: [PKStrokePoint] = []
    
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    private let successHaptic = UINotificationFeedbackGenerator()
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(spacing: isPad ? 30 : 16) {
            VStack(spacing: isPad ? 10 : 6) {
                Text("\(letter.wordDevanagari) \(letter.wordEmoji)")
                    .font(.custom("Devanagari Sangam MN", size: isPad ? 110 : 70))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                    .scaleEffect(wordScale)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text(letter.wordTransliteration)
                    .font(isPad ? .title3.bold() : .footnote.bold())
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.7))
            }
            .padding(.top, isPad ? 80 : 50)
            
            Spacer()
            
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: isPad ? 36 : 28)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: isPad ? 25 : 18, x: 0, y: isPad ? 12 : 8)
                
                if showOutline {
                    Text(letter.wordDevanagari)
                        .font(.custom("Devanagari Sangam MN", size: isPad ? 180 : 120))
                        .foregroundColor(showSuccess ? .green.opacity(0.2) : Color.gray.opacity(0.18))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .scaleEffect(showSuccess ? 1.04 : 1.0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                DrawingCanvas(canvasView: $canvasView, penWidth: $penWidth, isInputEnabled: isPad, onDrawingChanged: nil)
                    .frame(width: isPad ? 520 : 300, height: isPad ? 360 : 230)
                    .background(Color.clear)
                    .opacity(showSuccess ? 0.3 : 1.0)

                pencilOverlay
                
                Button(action: { showOutline.toggle() }) {
                    Image(systemName: showOutline ? "eye.slash" : "eye")
                        .font(.system(size: isPad ? 18 : 14, weight: .bold))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                        .padding(isPad ? 10 : 8)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                        )
                }
                .padding(isPad ? 16 : 12)
            }
            .frame(width: isPad ? 600 : 320, height: isPad ? 420 : 250)

            penThicknessControl
            
            Spacer()
            
            VStack(spacing: isPad ? 18 : 12) {
                VStack(spacing: isPad ? 6 : 4) {
                    Text(feedbackMessage)
                        .font(isPad ? .title3.bold() : .subheadline.bold())
                        .foregroundColor(showSuccess ? .green : Color(red: 0.15, green: 0.15, blue: 0.3).opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                }
                .frame(height: isPad ? 90 : 54)
                
                HStack(spacing: 28) {
                    clearButton
                    checkButton
                }
            }
            .padding(.bottom, isPad ? 50 : 24)
        }
        .padding()
        .animation(.easeInOut, value: showSuccess)
    }

    private var penThicknessControl: some View {
        VStack(spacing: 8) {
            Text("Pen Thickness")
                .font(isPad ? .subheadline.bold() : .caption.bold())
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.7))
            Picker("Pen Thickness", selection: $penWidth) {
                Text("Small").tag(CGFloat(4))
                Text("Medium").tag(CGFloat(6))
                Text("Large").tag(CGFloat(8))
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: isPad ? 360 : 260)
        }
    }

    private var pencilOverlay: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                if !isPad {
                    Circle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if !didSetInitialPencil {
                                        pencilPosition = value.location
                                        didSetInitialPencil = true
                                    }
                                    isPencilDragging = true
                                    pencilPosition = value.location
                                    updatePencilTracking(in: size)
                                    updatePencilStroke(at: value.location, in: size)
                                }
                                .onEnded { _ in
                                    isPencilDragging = false
                                    isPencilOnTrack = false
                                    finishPencilStroke()
                                }
                        )

                    Image(systemName: "pencil")
                        .font(.system(size: isPad ? 22 : 18, weight: .bold))
                        .foregroundColor(pencilColor)
                        .shadow(color: pencilShadowColor, radius: 6, x: 0, y: 2)
                        .position(currentPencilPosition(in: size))
                }
            }
            .onAppear {
                if !didSetInitialPencil {
                    pencilPosition = CGPoint(x: size.width * 0.15, y: size.height * 0.2)
                    didSetInitialPencil = true
                }
                buildOutlineMask(for: size)
            }
            .onChange(of: size) { newSize in
                buildOutlineMask(for: newSize)
                if !didSetInitialPencil {
                    pencilPosition = CGPoint(x: newSize.width * 0.15, y: newSize.height * 0.2)
                    didSetInitialPencil = true
                }
            }
        }
    }

    private var pencilColor: Color {
        if !isPencilDragging { return Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.7) }
        return isPencilOnTrack ? .green : .red
    }

    private var pencilShadowColor: Color {
        if !isPencilDragging { return Color.black.opacity(0.1) }
        return (isPencilOnTrack ? Color.green.opacity(0.4) : Color.red.opacity(0.4))
    }

    private func currentPencilPosition(in size: CGSize) -> CGPoint {
        let x = min(max(pencilPosition.x, 0), size.width)
        let y = min(max(pencilPosition.y, 0), size.height)
        return CGPoint(x: x, y: y)
    }

    private var pencilIconSize: CGFloat {
        isPad ? 22 : 18
    }

    private var pencilTipOffset: CGPoint {
        CGPoint(x: -pencilIconSize * 0.55, y: pencilIconSize * 0.35)
    }

    private func pencilTipPosition(in size: CGSize) -> CGPoint {
        let center = currentPencilPosition(in: size)
        let x = min(max(center.x + pencilTipOffset.x, 0), size.width)
        let y = min(max(center.y + pencilTipOffset.y, 0), size.height)
        return CGPoint(x: x, y: y)
    }

    private func updatePencilTracking(in size: CGSize) {
        guard let outlineMask else {
            isPencilOnTrack = false
            return
        }
        let position = pencilTipPosition(in: size)
        let scaleX = CGFloat(outlineMask.width) / size.width
        let scaleY = CGFloat(outlineMask.height) / size.height
        let maskX = Int(position.x * scaleX)
        let maskY = Int(position.y * scaleY)
        let radius = Int(isPad ? 8 : 6)
        isPencilOnTrack = outlineMask.isOnOutline(x: maskX, y: maskY, radius: radius)
    }

    private func buildOutlineMask(for size: CGSize) {
        let font = UIFont(name: "Devanagari Sangam MN", size: isPad ? 180 : 120) ?? UIFont.systemFont(ofSize: isPad ? 180 : 120)
        outlineMask = OutlineMask.make(text: letter.wordDevanagari, font: font, canvasSize: size)
    }

    private func updatePencilStroke(at location: CGPoint, in size: CGSize) {
        let clamped = pencilTipPosition(in: size)
        let point = PKStrokePoint(
            location: clamped,
            timeOffset: TimeInterval(Date().timeIntervalSinceReferenceDate),
            size: CGSize(width: penWidth, height: penWidth),
            opacity: 1,
            force: 1,
            azimuth: 0,
            altitude: .pi / 2
        )
        pencilStrokePoints.append(point)
        guard pencilStrokePoints.count > 1 else { return }

        let ink = PKInk(.pen, color: .darkGray)
        let strokePath = PKStrokePath(controlPoints: pencilStrokePoints, creationDate: Date())
        let stroke = PKStroke(ink: ink, path: strokePath)
        let existing = canvasView.drawing.strokes
        canvasView.drawing = PKDrawing(strokes: existing + [stroke])
    }

    private func finishPencilStroke() {
        pencilStrokePoints.removeAll()
    }
    
    private var clearButton: some View {
        Button(action: {
            haptic.impactOccurred()
            canvasView.clear()
            feedbackMessage = "Canvas cleared. Try again!"
            showSuccess = false
            pencilStrokePoints.removeAll()
        }) {
            Label("Clear", systemImage: "arrow.counterclockwise")
                .font(isPad ? .subheadline.bold() : .footnote.bold())
                .foregroundColor(.white)
                .padding(.vertical, isPad ? 16 : 12)
                .padding(.horizontal, isPad ? 28 : 20)
                .background(
                    Capsule()
                        .fill(Color.red.opacity(0.9))
                        .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                )
        }
    }
    
    private var checkButton: some View {
        Button(action: checkDrawing) {
            if isProcessing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(.vertical, isPad ? 16 : 12)
                    .padding(.horizontal, isPad ? 54 : 44)
                    .background(Capsule().fill(Color.orange))
            } else {
                Label("Check", systemImage: "checkmark.seal.fill")
                    .font(isPad ? .headline.bold() : .subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.vertical, isPad ? 16 : 12)
                    .padding(.horizontal, isPad ? 45 : 36)
                    .background(
                        Capsule()
                            .fill(Color.orange)
                            .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
            }
        }
        .disabled(isProcessing || showSuccess)
    }
    
    private func checkDrawing() {
        let drawing = canvasView.drawing
        let outline = outlineMask
        let canvasSize = canvasView.bounds.size
        let radius = isPad ? 10 : 8
        if drawing.bounds.isEmpty {
            feedbackMessage = "Please draw something first!"
            haptic.impactOccurred()
            return
        }
        isProcessing = true

        DispatchQueue.global(qos: .userInitiated).async {
            let accuracy = outline.map { outline in
                TracingMatcher.outlineMatchPercent(drawing: drawing, outline: outline, size: canvasSize, radius: radius)
            } ?? 0

            DispatchQueue.main.async {
                isProcessing = false

                if accuracy < 15 {
                    haptic.impactOccurred()
                    feedbackMessage = "Trace the outline a bit more"
                    showSuccess = false
                    return
                }

                playSuccessSound()
                successHaptic.notificationOccurred(.success)

                withAnimation(.spring()) {
                    showSuccess = true
                    wordScale = 1.1
                }

                feedbackMessage = "Great job!"

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    onCorrect()
                }
            }
        }
    }
    
    private func playSuccessSound() {
        AudioServicesPlaySystemSound(1025)
    }

}
