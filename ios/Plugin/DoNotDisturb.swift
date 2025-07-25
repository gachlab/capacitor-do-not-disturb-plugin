import Foundation
import UserNotifications

@objc public class DoNotDisturb: NSObject {
    private var callback: (() -> Void)?
    private var timer: Timer?
    private var lastState: Bool = false
    
    @objc public func isEnabled() -> Bool {
        // iOS doesn't provide API to detect Focus/DND state
        return false
    }
    
    @objc public func setEnabled(_ enabled: Bool) {
        // iOS doesn't allow programmatic DND control
    }
    
    @objc public func startListening(callback: @escaping () -> Void) {
        self.callback = callback
        lastState = isEnabled()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            let currentState = self.isEnabled()
            if currentState != self.lastState {
                self.lastState = currentState
                callback()
            }
        }
    }
    
    @objc public func stopListening() {
        timer?.invalidate()
        timer = nil
    }
}
