package com.gachlab.capacitor.dnd;

import android.Manifest;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.provider.Settings;

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
            notifyListeners("monitor", ret);
        });
    }

    @PluginMethod
    public void monitor(PluginCall call) {
        NotificationManager nm = (NotificationManager) getContext().getSystemService(Context.NOTIFICATION_SERVICE);
        if (!nm.isNotificationPolicyAccessGranted()) {
            Intent intent = new Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);
            getActivity().startActivity(intent);
        }
        JSObject ret = new JSObject();
        ret.put("enabled", implementation.isEnabled());
        call.resolve(ret);
    }

    @PluginMethod
    public void set(PluginCall call) {
        boolean enabled = call.getBoolean("enabled", false);
        NotificationManager nm = (NotificationManager) getContext().getSystemService(Context.NOTIFICATION_SERVICE);
        if (!nm.isNotificationPolicyAccessGranted()) {
            call.reject("Permission required: Go to Settings > Apps > [App Name] > Permissions > Do Not Disturb access");
            return;
        }
        implementation.setEnabled(enabled);
        JSObject ret = new JSObject();
        ret.put("enabled", implementation.isEnabled());
        notifyListeners("monitor", ret);
        call.resolve();
    }



    @Override
    protected void handleOnDestroy() {
        if (implementation != null) {
            implementation.stopListening();
        }
    }
}
