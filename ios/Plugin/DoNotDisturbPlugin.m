#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(DoNotDisturbPlugin, "DoNotDisturb",
           CAP_PLUGIN_METHOD(monitor, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(set, CAPPluginReturnPromise);
)
