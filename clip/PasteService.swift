//
//  PasteService.swift
//  clip
//
//  Created by Yılmaz Çakmakçı on 13.02.2026.
//

import ApplicationServices
import AppKit

enum PasteService {
    private static let vKeyCode: CGKeyCode = 9 // V key

    static var hasAccessibilityPermission: Bool {
        AXIsProcessTrustedWithOptions([
            kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: false
        ] as CFDictionary)
    }

    static func requestAccessibilityPermission() {
        _ = AXIsProcessTrustedWithOptions([
            kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true
        ] as CFDictionary)
    }

    static func pasteToFrontmostApp() {
        guard hasAccessibilityPermission else {
            requestAccessibilityPermission()
            return
        }

        guard let keyDown = CGEvent(
            keyboardEventSource: nil,
            virtualKey: vKeyCode,
            keyDown: true
        ),
        let keyUp = CGEvent(
            keyboardEventSource: nil,
            virtualKey: vKeyCode,
            keyDown: false
        ) else { return }

        keyDown.flags = .maskCommand
        keyUp.flags = .maskCommand
        keyDown.post(tap: .cgAnnotatedSessionEventTap)
        keyUp.post(tap: .cgAnnotatedSessionEventTap)
    }
}
