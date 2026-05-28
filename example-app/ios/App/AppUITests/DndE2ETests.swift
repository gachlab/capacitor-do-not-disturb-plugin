// SPDX-License-Identifier: MIT
// Copyright (c) 2026 gachlab
//
// End-to-end test for the DND plugin on the iOS Simulator.
//
// iOS does NOT expose a programmatic way to toggle Focus/DND from an automated
// test, so the `dndStateChanged` EVENT is covered by the manual checklist in
// TESTING.md. This XCUITest verifies the part that IS automatable end-to-end:
// the JS↔native bridge round-trip — tapping `isEnabled` resolves the native
// call and renders a concrete DND state in the WebView.

import XCTest

final class DndE2ETests: XCTestCase {

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        let webView = app.webViews.firstMatch
        XCTAssert(webView.waitForExistence(timeout: 20), "WebView did not load in 20 s")
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testIsEnabledRoundTrip() throws {
        let webView = app.webViews.firstMatch
        let btn = webView.buttons["isEnabled"]
        XCTAssert(btn.waitForExistence(timeout: 30), "isEnabled button not found in WebView")
        btn.tap()

        // The dnd-state span starts at "unknown" and flips to "on"/"off" once the
        // native isEnabled() call resolves through the bridge.
        let resolved = NSPredicate(format: "label == 'on' OR label == 'off'")
        let stateEl = webView.staticTexts.matching(resolved).firstMatch
        XCTAssert(
            stateEl.waitForExistence(timeout: 10),
            "isEnabled() round-trip did not resolve to a concrete DND state"
        )
    }
}
