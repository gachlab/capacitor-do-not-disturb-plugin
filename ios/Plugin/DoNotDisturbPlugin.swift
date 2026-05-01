import Foundation
import Capacitor

@objc(DoNotDisturbPlugin)
public class DoNotDisturbPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "DoNotDisturbPlugin"
    public let jsName = "DoNotDisturb"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "isEnabled", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setEnabled", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = DoNotDisturb()

    public override func load() {
        implementation.startListening { [weak self] in
            guard let self = self else { return }
            self.implementation.isEnabled { enabled in
                self.notifyListeners("dndStateChanged", data: ["enabled": enabled])
            }
        }
    }

    @objc func isEnabled(_ call: CAPPluginCall) {
        implementation.isEnabled { enabled in
            call.resolve(["enabled": enabled])
        }
    }

    @objc func setEnabled(_ call: CAPPluginCall) {
        call.reject("iOS does not allow programmatic DND control")
    }

    deinit {
        implementation.stopListening()
    }
}
