package com.gachlab.capacitor.dnd;

import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

public class DoNotDisturb {
    private Context context;
    private BroadcastReceiver receiver;
    private Runnable callback;
    
    public DoNotDisturb(Context context) {
        this.context = context;
    }
    
    public boolean isEnabled() {
        NotificationManager nm = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        return nm.getCurrentInterruptionFilter() != NotificationManager.INTERRUPTION_FILTER_ALL;
    }
    
    public void setEnabled(boolean enabled) {
        NotificationManager nm = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (!nm.isNotificationPolicyAccessGranted()) {
            return;
        }
        nm.setInterruptionFilter(enabled ? NotificationManager.INTERRUPTION_FILTER_NONE : NotificationManager.INTERRUPTION_FILTER_ALL);
    }
    
    public void startListening(Runnable callback) {
        this.callback = callback;
        receiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (callback != null) callback.run();
            }
        };
        context.registerReceiver(receiver, new IntentFilter(NotificationManager.ACTION_INTERRUPTION_FILTER_CHANGED));
    }
    
    public void stopListening() {
        if (receiver != null) {
            context.unregisterReceiver(receiver);
            receiver = null;
        }
    }
}
