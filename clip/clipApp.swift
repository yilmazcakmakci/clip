//
//  clipApp.swift
//  clip
//
//  Created by Yılmaz Çakmakçı on 13.02.2026.
//

import SwiftUI

@main
struct clipApp: App {
    @StateObject private var store = ClipboardStore()

    var body: some Scene {
        MenuBarExtra {
            ClipboardMenuView(store: store)
        } label: {
            Image(systemName: "doc.on.clipboard")
        }
    }
}
