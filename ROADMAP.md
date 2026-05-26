# Roadmap — @gachlab/capacitor-dnd-plugin

**Contexto:** Detecta el estado de "No Molestar" del dispositivo. Caso de uso principal: saber si el teléfono **va a sonar** (notificaciones/llamadas) — útil para apps de operación/campo donde "no me sonó" es un problema real. El roadmap amplía el alcance de "solo DND" a **estado de interrupción** completo.

**Estado actual:** v2.0.1 — Android nativo (`NotificationManager`, requiere `ACCESS_NOTIFICATION_POLICY`); iOS heurístico (Apple no expone el estado de Focus/DND); Web es no-op honesto. Bump AGP 9 mergeado, sin release npm.

---

## Fase 1 — Eventos con timestamp

- Añadir `timestamp` a `dndStateChanged` para que el consumidor pueda llevar bitácora.
- El plugin **emite** el evento; el reporte lo decide el consumidor. Para reporte confiable en background ver `event-sink`.

## Fase 2 — Estado de interrupción (ampliación del alcance)

Hoy "no me suena" no es solo DND: también puede ser timbre en silencio/vibración o volumen bajo. Ampliar el plugin para cubrir todo el dominio en una sola API.

**API nueva:**
```typescript
getInterruptionState(): Promise<InterruptionState>

interface InterruptionState {
  dnd: boolean;                                   // ya existe (isEnabled)
  ringerMode: 'normal' | 'vibrate' | 'silent';    // nuevo
  volume: { ring: number; notification: number };  // 0..1, nuevo
  timestamp: number;
}
```

**Eventos nuevos** (además de `dndStateChanged`):
```typescript
'ringerModeChanged' → { ringerMode, timestamp }
'volumeChanged'     → { stream: 'ring' | 'notification', volume, timestamp }
```

- Android: `AudioManager.getRingerMode()` + `getStreamVolume()`; observar cambios con un `ContentObserver` sobre `Settings.System` (requiere un componente vivo — ver Fase 3).
- Mantener `isEnabled()` / `setEnabled()` para compatibilidad.

## Fase 3 — Captura en background

El `BroadcastReceiver` de DND ya corre en background; el observer de volumen necesita un servicio vivo. Integrar con `event-sink` (servicio + cola compartidos) para no perder eventos cuando el WebView no está activo.

---

## Notas de plataforma

- **Android primero.** Es la plataforma objetivo.
- **iOS:** se mantiene la heurística actual sin inversión nueva (Apple no expone DND/Focus ni ringer mode de forma fiable). Documentar como best-effort.
- **Web:** no-op (sin capacidad nativa).
