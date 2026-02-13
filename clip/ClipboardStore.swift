//
//  ClipboardStore.swift
//  clip
//
//  Created by Yılmaz Çakmakçı on 13.02.2026.
//

import AppKit
import Combine
import SwiftUI

private let maxHistoryCountKey = "maxHistoryCount"
private let defaultMaxHistoryCount = 20

final class ClipboardStore: ObservableObject {
    @Published var history: [String] = []
    @Published var maxHistoryCount: Int

    private let pasteboard = NSPasteboard.general
    private var lastChangeCount: Int = 0
    private var timer: Timer?

    init() {
        self.maxHistoryCount = UserDefaults.standard.object(forKey: maxHistoryCountKey) as? Int ?? defaultMaxHistoryCount
        self.lastChangeCount = pasteboard.changeCount
        startPolling()
    }

    deinit {
        timer?.invalidate()
    }

    private func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.checkClipboard()
            }
        }
        timer?.tolerance = 0.1
    }

    private func checkClipboard() {
        let changeCount = pasteboard.changeCount
        guard changeCount != lastChangeCount else { return }
        lastChangeCount = changeCount

        guard let string = pasteboard.string(forType: .string), !string.isEmpty else { return }
        guard string != history.first else { return }

        addToHistory(string)
    }

    private func addToHistory(_ text: String) {
        history.removeAll { $0 == text }
        history.insert(text, at: 0)
        trimHistoryIfNeeded()
    }

    private func trimHistoryIfNeeded() {
        if history.count > maxHistoryCount {
            history = Array(history.prefix(maxHistoryCount))
        }
    }

    func copyToPasteboard(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }

    func setMaxHistoryCount(_ count: Int) {
        maxHistoryCount = count
        UserDefaults.standard.set(count, forKey: maxHistoryCountKey)
        trimHistoryIfNeeded()
    }

    func clearHistory() {
        history.removeAll()
    }
}
