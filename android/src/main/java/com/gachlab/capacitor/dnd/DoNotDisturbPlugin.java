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

    private DoNotDisturb implementation = new DoNotDisturb();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }
}
