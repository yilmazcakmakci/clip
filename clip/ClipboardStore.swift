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

struct ClipboardItem: Identifiable, Equatable {
    let id = UUID()
    let text: String
    var isPinned: Bool
}

final class ClipboardStore: ObservableObject {
    @Published var history: [ClipboardItem] = []
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
        guard string != history.first?.text else { return }

        addToHistory(string)
    }

    private func addToHistory(_ text: String) {
        let isPinned = history.first(where: { $0.text == text })?.isPinned ?? false
        history.removeAll { $0.text == text }

        let newItem = ClipboardItem(text: text, isPinned: isPinned)
        if newItem.isPinned {
            history.insert(newItem, at: 0)
        } else {
            let insertIndex = history.prefix { $0.isPinned }.count
            history.insert(newItem, at: insertIndex)
        }

        trimHistoryIfNeeded()
    }

    private func trimHistoryIfNeeded() {
        let pinnedItems = history.filter { $0.isPinned }
        let unpinnedItems = history.filter { !$0.isPinned }
        history = pinnedItems + Array(unpinnedItems.prefix(maxHistoryCount))
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

    func togglePin(for item: ClipboardItem) {
        guard let index = history.firstIndex(where: { $0.id == item.id }) else { return }

        var updatedItem = history.remove(at: index)
        updatedItem.isPinned.toggle()

        if updatedItem.isPinned {
            history.insert(updatedItem, at: 0)
        } else {
            let insertIndex = history.prefix { $0.isPinned }.count
            history.insert(updatedItem, at: insertIndex)
        }

        trimHistoryIfNeeded()
    }

    func clearHistory() {
        history.removeAll { !$0.isPinned }
    }
}
