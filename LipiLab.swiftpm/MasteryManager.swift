import Foundation
import SwiftUI

enum MasteryTier: Int, Codable {
    case notStarted = 0
    case tier1 = 1
    case tier2 = 2
    case tier3 = 3
}

@MainActor
class MasteryManager: ObservableObject {
    static let shared = MasteryManager()
    
    @Published var progress: [String: MasteryTier] = [:]
    @Published var wordProgress: [String: MasteryTier] = [:]
    
    private let storageKey = "lipi_lab_progress_v2" // New key for the new system
    private let wordStorageKey = "lipi_lab_word_progress_v1"
    
    private init() {
        loadProgress()
    }
    
    func updateProgress(for letter: String) {
        let current = (progress[letter] ?? .notStarted).rawValue
        if current < 3 {
            let nextTier = MasteryTier(rawValue: current + 1) ?? .tier3
            progress[letter] = nextTier
        }
        saveProgress()
    }

    func updateWordProgress(for letter: String) {
        let current = (wordProgress[letter] ?? .notStarted).rawValue
        if current < 3 {
            let nextTier = MasteryTier(rawValue: current + 1) ?? .tier3
            wordProgress[letter] = nextTier
        }
        saveProgress()
    }
    
    func getTier(for letter: String) -> MasteryTier {
        return progress[letter] ?? .notStarted
    }

    func getWordTier(for letter: String) -> MasteryTier {
        return wordProgress[letter] ?? .notStarted
    }
    
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
        if let encoded = try? JSONEncoder().encode(wordProgress) {
            UserDefaults.standard.set(encoded, forKey: wordStorageKey)
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: MasteryTier].self, from: data) {
            progress = decoded
        }
        if let data = UserDefaults.standard.data(forKey: wordStorageKey),
           let decoded = try? JSONDecoder().decode([String: MasteryTier].self, from: data) {
            wordProgress = decoded
        }
    }
    
    func resetProgress() {
        progress = [:]
        wordProgress = [:]
        UserDefaults.standard.removeObject(forKey: storageKey)
        UserDefaults.standard.removeObject(forKey: wordStorageKey)
    }
}
