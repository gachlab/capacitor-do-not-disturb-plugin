import { DoNotDisturb } from '@gachlab/capacitor-dnd-plugin';

function addLog(message) {
    const log = document.getElementById('log');
    const time = new Date().toLocaleTimeString();
    log.innerHTML = `<div>[${time}] ${message}</div>` + log.innerHTML;
}

function updateStatus(enabled) {
    const status = `DND Enabled: ${enabled}`;
    document.getElementById('status').innerHTML = status;
    return status;
}

// Listen for DND state changes using monitor event
DoNotDisturb.addListener('monitor', (state) => {
    const status = updateStatus(state.enabled);
    addLog(`🔔 State changed: ${status}`);
});

window.checkStatus = async () => {
    addLog('Checking DND status...');
    try {
        const result = await DoNotDisturb.monitor();
        const status = updateStatus(result.enabled);
        addLog(`✓ ${status}`);
    } catch (error) {
        const errorMsg = `Error: ${error.message}`;
        document.getElementById('status').innerHTML = errorMsg;
        addLog(`✗ ${errorMsg}`);
    }
}

window.enableDND = async () => {
    addLog('Enabling DND...');
    try {
        await DoNotDisturb.set({ enabled: true });
        addLog('✓ DND enabled');
    } catch (error) {
        addLog(`✗ Error: ${error.message}`);
    }
}

window.disableDND = async () => {
    addLog('Disabling DND...');
    try {
        await DoNotDisturb.set({ enabled: false });
        addLog('✓ DND disabled');
    } catch (error) {
        addLog(`✗ Error: ${error.message}`);
    }
}



