import Foundation
import UIKit
import UserNotifications

@objc public class DoNotDisturb: NSObject {
    private var callback: (() -> Void)?
    private var lastState: Bool?
    private var isListening = false

    @objc public func isEnabled(completion: @escaping (Bool) -> Void) {
        // iOS doesn't expose Focus/DND state directly.
        // We use notification settings as a proxy: if notifications are
        // silenced (alertSetting == .disabled while authorized), DND is likely on.
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let enabled = settings.authorizationStatus == .authorized
                && settings.notificationCenterSetting == .enabled
                && settings.alertSetting == .disabled
            completion(enabled)
        }
    }

    @objc public func startListening(callback: @escaping () -> Void) {
        guard !isListening else { return }
        isListening = true
        self.callback = callback

        // iOS has no direct DND/Focus change event. Re-check whenever the app
        // returns to the foreground — that's when the user has had an
        // opportunity to toggle DND from Control Center or Settings.
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(handleForegroundEvent),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(handleForegroundEvent),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc public func stopListening() {
        guard isListening else { return }
        isListening = false
        NotificationCenter.default.removeObserver(self)
        callback = nil
        lastState = nil
    }

    @objc private func handleForegroundEvent() {
        isEnabled { [weak self] currentState in
            guard let self = self, self.isListening else { return }
            let previous = self.lastState
            self.lastState = currentState
            if previous != currentState {
                self.callback?()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
