import UIKit

struct OutlineMask {
    let width: Int
    let height: Int
    let data: [UInt8]

    static func make(text: String, font: UIFont, canvasSize: CGSize) -> OutlineMask? {
        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: OutlineMask.renderFormat())
        let image = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: canvasSize))

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let textSize = (text as NSString).size(withAttributes: attributes)
            let origin = CGPoint(
                x: (canvasSize.width - textSize.width) / 2,
                y: (canvasSize.height - textSize.height) / 2
            )
            (text as NSString).draw(at: origin, withAttributes: attributes)
        }

        guard let cgImage = image.cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = width * 4
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var mask = [UInt8](repeating: 0, count: width * height)
        for y in 0..<height {
            for x in 0..<width {
                let index = (y * width + x) * 4
                let r = pixels[index]
                let g = pixels[index + 1]
                let b = pixels[index + 2]
                let a = pixels[index + 3]
                if a > 0 {
                    let brightness = (Int(r) + Int(g) + Int(b)) / 3
                    if brightness < 200 {
                        mask[y * width + x] = 1
                    }
                }
            }
        }

        return OutlineMask(width: width, height: height, data: mask)
    }

    func isOnOutline(x: Int, y: Int, radius: Int) -> Bool {
        guard width > 0, height > 0 else { return false }
        let clampedX = min(max(x, 0), width - 1)
        let clampedY = min(max(y, 0), height - 1)
        let r = max(radius, 1)

        let startX = max(clampedX - r, 0)
        let endX = min(clampedX + r, width - 1)
        let startY = max(clampedY - r, 0)
        let endY = min(clampedY + r, height - 1)

        for py in startY...endY {
            for px in startX...endX {
                let dx = px - clampedX
                let dy = py - clampedY
                if (dx * dx + dy * dy) <= (r * r) {
                    if data[py * width + px] == 1 {
                        return true
                    }
                }
            }
        }
        return false
    }

    private static func renderFormat() -> UIGraphicsImageRendererFormat {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return format
    }
}
