import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct DrawingCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var penWidth: CGFloat
    var isInputEnabled: Bool
    var onDrawingChanged: ((UIImage) -> Void)?
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.isUserInteractionEnabled = isInputEnabled
        updateTool(for: canvasView)
        
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.delegate = context.coordinator
        
        return canvasView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDrawingChanged: onDrawingChanged)
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        updateTool(for: uiView)
        uiView.isUserInteractionEnabled = isInputEnabled
    }

    private func updateTool(for canvasView: PKCanvasView) {
        let color: UIColor = .darkGray
        if #available(iOS 17.0, *) {
            canvasView.tool = PKInkingTool(.fountainPen, color: color, width: penWidth)
        } else {
            canvasView.tool = PKInkingTool(.pen, color: color, width: penWidth)
        }
    }
    
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        private let onDrawingChanged: ((UIImage) -> Void)?
        private var workItem: DispatchWorkItem?
        
        init(onDrawingChanged: ((UIImage) -> Void)?) {
            self.onDrawingChanged = onDrawingChanged
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            workItem?.cancel()
            let item = DispatchWorkItem { [weak canvasView] in
                guard let canvasView else { return }
                let image = canvasView.getAsImage()
                self.onDrawingChanged?(image)
            }
            workItem = item
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
        }
    }
}

extension PKCanvasView {
    private static let ciContext = CIContext()

    func getAsImage() -> UIImage {
        let drawing = self.drawing
        let padding: CGFloat = 32
        let canvasBounds = self.bounds
        
        guard !canvasBounds.isEmpty else {
            return UIImage()
        }
        
        let size = CGSize(width: canvasBounds.width + (padding * 2), height: canvasBounds.height + (padding * 2))
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            let drawingImage = drawing.image(from: canvasBounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: CGRect(x: padding, y: padding, width: canvasBounds.width, height: canvasBounds.height))
        }
        
        guard let ciImage = CIImage(image: image) else {
            return image
        }
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.saturation = 0
        filter.contrast = 1.2
        filter.brightness = 0
        if let output = filter.outputImage,
           let cgImage = PKCanvasView.ciContext.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage)
        }
        return image
    }
    
    func clear() {
        self.drawing = PKDrawing()
    }
}
