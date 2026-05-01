import Foundation
import UserNotifications

@objc public class DoNotDisturb: NSObject {
    private var callback: (() -> Void)?
    private var timer: Timer?
    private var lastState: Bool = false

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
        self.callback = callback
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
                self?.isEnabled { currentState in
                    guard let self = self else { return }
                    if currentState != self.lastState {
                        self.lastState = currentState
                        callback()
                    }
                }
            }
        }
    }

    @objc public func stopListening() {
        timer?.invalidate()
        timer = nil
        callback = nil
    }
}
