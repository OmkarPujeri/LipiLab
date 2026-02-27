import Foundation
import UIKit
@preconcurrency import Vision

@MainActor
final class VisionManager {
    static let shared = VisionManager()
    
    private init() {} // Ensure singleton usage
    
    func recognizeHindi(from image: UIImage, completion: @escaping (String?, Float) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil, 0)
            return
        }
        
        // Use a Task to bridge to background work while keeping the completion on the main actor
        Task {
            let result: (String?, Float) = await Task.detached(priority: .userInitiated) { () -> (String?, Float) in
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                var recognizedText: String?
                var confidenceValues: [Float] = []
                
                let request = VNRecognizeTextRequest { request, error in
                    let observations = request.results as? [VNRecognizedTextObservation]
                    let recognizedStrings = observations?.compactMap { observation in
                        let candidate = observation.topCandidates(1).first
                        if let confidence = candidate?.confidence {
                            confidenceValues.append(confidence)
                        }
                        return candidate?.string
                    }
                    recognizedText = recognizedStrings?.joined(separator: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                request.recognitionLanguages = ["hi-IN"]
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = false
                
                do {
                    try requestHandler.perform([request])
                } catch {
                    return (nil, 0)
                }
                let averageConfidence = confidenceValues.isEmpty ? 0 : (confidenceValues.reduce(0, +) / Float(confidenceValues.count))
                return (recognizedText, averageConfidence)
            }.value
            
            // Back on main actor here
            completion(result.0, result.1)
        }
    }
}
