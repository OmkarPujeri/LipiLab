import CoreGraphics
import PencilKit

struct TracingMatcher {
    static func outlineMatchPercent(drawing: PKDrawing, outline: OutlineMask, size: CGSize, radius: Int) -> Int {
        let points = drawingPoints(from: drawing)
        guard !points.isEmpty, size.width > 0, size.height > 0 else { return 0 }
        var hitCount = 0

        for point in points {
            let maskX = Int(point.x / size.width * CGFloat(outline.width))
            let maskY = Int(point.y / size.height * CGFloat(outline.height))
            if outline.isOnOutline(x: maskX, y: maskY, radius: radius) {
                hitCount += 1
            }
        }

        let percent = Int(round((Double(hitCount) / Double(points.count)) * 100))
        return max(0, min(100, percent))
    }

    private static func drawingPoints(from drawing: PKDrawing) -> [CGPoint] {
        var points: [CGPoint] = []
        for stroke in drawing.strokes {
            for point in stroke.path {
                points.append(point.location)
            }
        }
        return points
    }
}
