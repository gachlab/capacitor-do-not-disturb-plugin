package com.gachlab.capacitor.dnd;

import android.Manifest;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;

@CapacitorPlugin(name = "DoNotDisturb", permissions = {
        @Permission(alias = "notifications-policy", strings = { Manifest.permission.ACCESS_NOTIFICATION_POLICY })
})
public class DoNotDisturbPlugin extends Plugin {

    private DoNotDisturb implementation;

    @Override
    public void load() {
        implementation = new DoNotDisturb(getContext());
        implementation.startListening(() -> {
            JSObject ret = new JSObject();
            ret.put("enabled", implementation.isEnabled());
            notifyListeners("dndStateChanged", ret);
        });
    }

    @PluginMethod
    public void isEnabled(PluginCall call) {
        try {
            JSObject ret = new JSObject();
            ret.put("enabled", implementation.isEnabled());
            call.resolve(ret);
        } catch (Exception e) {
            call.reject("Failed to check DND state", e);
        }
    }

    @PluginMethod
    public void setEnabled(PluginCall call) {
        try {
            boolean enabled = call.getBoolean("enabled", false);
            implementation.setEnabled(enabled);
            call.resolve();
        } catch (SecurityException e) {
            call.reject("Permission required: enable Do Not Disturb access in Settings", e);
        } catch (Exception e) {
            call.reject("Failed to set DND state", e);
        }
    }

    @Override
    protected void handleOnDestroy() {
        if (implementation != null) {
            implementation.stopListening();
        }
    }
}
