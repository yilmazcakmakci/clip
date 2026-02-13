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

    var body: some View {
        if store.history.isEmpty {
            Text("No copies yet")
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(minWidth: 200)
        } else {
            ForEach(Array(store.history.enumerated()), id: \.offset) { _, item in
                Button {
                    pasteItem(item)
                } label: {
                    Text(previewText(item))
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
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

        Button("Quit clip") {
            NSApplication.shared.terminate(nil)
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
