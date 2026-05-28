package com.gachlab.capacitor.dnd;

import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Looper;
import androidx.test.core.app.ApplicationProvider;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

/**
 * Unit tests for the pure DoNotDisturb implementation, running on Robolectric so
 * the real NotificationManager / BroadcastReceiver plumbing is exercised with a
 * shadowed Android framework (no device needed).
 */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 34)
public class DoNotDisturbTest {

    private Context context() {
        return ApplicationProvider.getApplicationContext();
    }

    private NotificationManager nm() {
        return (NotificationManager) context().getSystemService(Context.NOTIFICATION_SERVICE);
    }

    @Test
    public void isEnabled_isFalse_whenInterruptionFilterAll() {
        nm().setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL);
        assertFalse(new DoNotDisturb(context()).isEnabled());
    }

    @Test
    public void isEnabled_isTrue_whenInterruptionFilterNotAll() {
        nm().setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_PRIORITY);
        assertTrue(new DoNotDisturb(context()).isEnabled());
    }

    @Test
    public void startListening_firesCallback_onInterruptionFilterChanged() {
        DoNotDisturb dnd = new DoNotDisturb(context());
        final int[] hits = { 0 };
        dnd.startListening(() -> hits[0]++);

        context().sendBroadcast(new Intent(NotificationManager.ACTION_INTERRUPTION_FILTER_CHANGED));
        shadowOf(Looper.getMainLooper()).idle();

        assertEquals(1, hits[0]);
        dnd.stopListening();
    }

    @Test
    public void stopListening_unregisters_soNoMoreCallbacks() {
        DoNotDisturb dnd = new DoNotDisturb(context());
        final int[] hits = { 0 };
        dnd.startListening(() -> hits[0]++);
        dnd.stopListening();

        context().sendBroadcast(new Intent(NotificationManager.ACTION_INTERRUPTION_FILTER_CHANGED));
        shadowOf(Looper.getMainLooper()).idle();

        assertEquals(0, hits[0]);
    }

    @Test
    public void stopListening_withoutStart_doesNotThrow() {
        new DoNotDisturb(context()).stopListening();
    }
}
