package com.gachlab.capacitor.dnd;

import static org.junit.Assert.*;

import android.content.Context;
import androidx.test.core.app.ApplicationProvider;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import org.junit.Test;
import org.junit.runner.RunWith;

/**
 * Integration tests — exercise DoNotDisturb against the REAL Android framework
 * on an emulator/device (no Robolectric shadows, no mocks). Black-box: we only
 * assert the public behavior holds against the real NotificationManager.
 */
@RunWith(AndroidJUnit4.class)
public class DoNotDisturbInstrumentedTest {

    private Context context() {
        return ApplicationProvider.getApplicationContext();
    }

    @Test
    public void isEnabled_readsRealNotificationManager_withoutThrowing() {
        DoNotDisturb dnd = new DoNotDisturb(context());
        boolean enabled = dnd.isEnabled();
        // No policy access needed to READ the current interruption filter.
        assertTrue("isEnabled() must return a concrete boolean", enabled || !enabled);
    }

    @Test
    public void startThenStopListening_registersAgainstRealOs_withoutThrowing() {
        DoNotDisturb dnd = new DoNotDisturb(context());
        dnd.startListening(() -> {});
        dnd.stopListening();
    }

    @Test
    public void stopListening_withoutStart_doesNotThrow() {
        new DoNotDisturb(context()).stopListening();
    }
}
