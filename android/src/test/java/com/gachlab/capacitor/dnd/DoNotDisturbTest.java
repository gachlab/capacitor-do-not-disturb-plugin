package com.gachlab.capacitor.dnd;

import static org.junit.Assert.*;

import org.junit.Test;

public class DoNotDisturbTest {

    @Test
    public void stopListening_withoutStart_doesNotThrow() {
        DoNotDisturb dnd = new DoNotDisturb(null);
        dnd.stopListening();
    }

    @Test
    public void stopListening_calledTwice_doesNotThrow() {
        DoNotDisturb dnd = new DoNotDisturb(null);
        dnd.stopListening();
        dnd.stopListening();
    }

    @Test
    public void isEnabled_withNullContext_throwsNPE() {
        DoNotDisturb dnd = new DoNotDisturb(null);
        try {
            dnd.isEnabled();
            fail("Expected NullPointerException");
        } catch (NullPointerException e) {
            // Context is null, so getSystemService throws NPE
        }
    }

    @Test
    public void setEnabled_withNullContext_throwsNPE() {
        DoNotDisturb dnd = new DoNotDisturb(null);
        try {
            dnd.setEnabled(true);
            fail("Expected NullPointerException");
        } catch (NullPointerException e) {
            // Context is null, so getSystemService throws NPE
        }
    }

    @Test
    public void startListening_withNullContext_throwsNPE() {
        DoNotDisturb dnd = new DoNotDisturb(null);
        try {
            dnd.startListening(() -> {});
            fail("Expected NullPointerException");
        } catch (NullPointerException e) {
            // Context is null, so registerReceiver throws NPE
        }
    }
}
