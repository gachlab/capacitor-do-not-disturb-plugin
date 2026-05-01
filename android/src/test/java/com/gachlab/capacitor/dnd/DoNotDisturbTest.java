package com.gachlab.capacitor.dnd;

import static org.junit.Assert.*;

import org.junit.Test;

public class DoNotDisturbTest {

    @Test
    public void constructor_doesNotThrowWithNullContext() {
        // Should not throw during construction
        DoNotDisturb dnd = new DoNotDisturb(null);
        assertNotNull(dnd);
    }

    @Test
    public void stopListening_doesNotThrowWhenNotStarted() {
        DoNotDisturb dnd = new DoNotDisturb(null);
        // Should not throw when stopping without starting
        dnd.stopListening();
    }
}
