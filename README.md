# @gachlab/capacitor-dnd-plugin

A plugin to set and monitor the Do Not Disturb state

## Install

```bash
npm install @gachlab/capacitor-dnd-plugin
npx cap sync
```

## API

<docgen-index>

* [`monitor()`](#monitor)
* [`set(...)`](#set)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### monitor()

```typescript
monitor() => Promise<{ enabled: boolean; }>
```

**Returns:** <code>Promise&lt;{ enabled: boolean; }&gt;</code>

--------------------


### set(...)

```typescript
set(options: { enabled: boolean; }) => Promise<void>
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

--------------------

</docgen-api>
