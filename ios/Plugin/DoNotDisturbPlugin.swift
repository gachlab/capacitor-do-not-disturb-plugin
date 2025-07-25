import Foundation
import Capacitor

@objc(DoNotDisturbPlugin)
public class DoNotDisturbPlugin: CAPPlugin {
    private let implementation = DoNotDisturb()

    public override func load() {
        implementation.startListening {
            self.notifyListeners("monitor", data: [
                "enabled": self.implementation.isEnabled()
            ])
        }
    }

    @objc func monitor(_ call: CAPPluginCall) {
        call.resolve([
            "enabled": implementation.isEnabled()
        ])
    }
    
    @objc func set(_ call: CAPPluginCall) {
        call.reject("iOS doesn't allow programmatic DND control")
    }
    


    deinit {
        implementation.stopListening()
    }
}
