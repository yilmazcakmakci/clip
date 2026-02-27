//
//  ClipboardMenuView.swift
//  clip
//
//  Created by Yılmaz Çakmakçı on 13.02.2026.
//

import SwiftUI

struct ClipboardMenuView: View {
    @ObservedObject var store: ClipboardStore

    private let previewLength = 50

    private var pinnedItems: [ClipboardItem] {
        store.history.filter { $0.isPinned }
    }

    private var unpinnedItems: [ClipboardItem] {
        store.history.filter { !$0.isPinned }
    }

    var body: some View {
        if store.history.isEmpty {
            Text("No copies yet")
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(minWidth: 200)
        } else {
            if !pinnedItems.isEmpty {
                ForEach(pinnedItems) { item in
                    itemButton(for: item)
                }

                Divider()
            }

            ForEach(unpinnedItems) { item in
                itemButton(for: item)
            }
        }

        Divider()

        Menu("History Limit") {
            Button("10") { store.setMaxHistoryCount(10) }
            Button("20") { store.setMaxHistoryCount(20) }
            Button("50") { store.setMaxHistoryCount(50) }
        }

        Button("Clear History") {
            store.clearHistory()
        }

        Divider()

        Text("⌥ Click to pin/unpin")
            .font(.caption)
            .foregroundStyle(.tertiary)

        Button("Quit clip") {
            NSApplication.shared.terminate(nil)
        }
    }

    private func itemButton(for item: ClipboardItem) -> some View {
        Button {
            if NSEvent.modifierFlags.contains(.option) {
                store.togglePin(for: item)
            } else {
                pasteItem(item.text)
            }
        } label: {
            if item.isPinned {
                Label(previewText(item.text), systemImage: "pin.fill")
            } else {
                Text(previewText(item.text))
            }
        }
    }

    private func previewText(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= previewLength {
            return trimmed
        }
        return String(trimmed.prefix(previewLength)) + "..."
    }

    private func pasteItem(_ text: String) {
        store.copyToPasteboard(text)
        PasteService.pasteToFrontmostApp()
    }
}

