<div align="center">
  <img src="https://cdn.gastrolize.com/lightning.png" width="300"/>
</div>

# ⚡ Lightning Overlay

A **Flutter package** that adds a dynamic lightning overlay effect to any widget.  
It’s designed to create an elegant, animated highlight — **similar to Skeletonizer**, but **without background blocks or shimmer effects**.  
Perfect for emphasizing UI elements, visual feedback, or attention-grabbing moments in your app.

---

## 🎯 Goal

The goal of this package is to provide a **Skeletonizer-like animation**, but:
- ❌ *without* a static background or placeholder layer  
- ❌ *without* shimmer gradients  
- ✅ *with* a clean, lightning-style overlay animation that can be applied to any widget seamlessly  

---

## ✨ Features

- ⚡ Beautiful lightning overlay animation  
- 🕹️ Three animation control modes  
- 🔁 Optional infinite repeat mode  
- 🎨 Customizable overlay color, curves, and durations  
- ↔️ Animation direction control (left → right or right → left)  
- 🟦 Supports rounded corners and any widget type  

---

## 🚀 Control Modes

The Lightning effect can be controlled in **three different ways**:

### 1. **Auto-Start Mode**
The animation automatically starts after a specified delay (`delayDuration`).

```dart
Lightning(
  child: MyWidget(),
  delayDuration: Duration(milliseconds: 800),
  autoStart: true,
)
```

**Tip:**  
Set both `delayDuration` and `pauseDuration` for smooth automatic playback.  
If the reverse animation doesn’t start, try increasing the `pauseDuration`.

---

### 2. **Controller Mode**
Manually trigger the animation using a `LightningController`.

```dart
final controller = LightningController();

Lightning(
  controller: controller,
  child: MyWidget(),
);

// Later in your code:
controller.animateIn();
await Future.delayed(Duration(milliseconds: 500));
controller.animateOut();
```

| Function | Description |
|-----------|--------------|
| `animateIn()` | Starts the lightning overlay (cover) animation |
| `animateOut()` | Starts the uncovering (fade-out) animation |

⚠️ You must **wait until `animateIn()` is finished** before calling `animateOut()`.

---

### 3. **Gesture Mode**
Let users trigger the animation by tapping the widget.

```dart
Lightning(
  useGesture: true,
  child: MyWidget(),
)
```

- **Tap down** → starts the lightning effect  
- **Tap up** → reverses the effect  
- **Tap cancel** → stops the effect  

---

## ⚠️ Compatibility Notes

- `repeatInfinity` **cannot** be used together with `useGesture = true`,  
  since repeat animations run automatically without user input.  
- For automatic or repeat modes, make sure `autoStart = true` and a valid `delayDuration` is set.  
- When using rounded corners on your child widget, pass the same `borderRadius` to Lightning to ensure smooth edges.  

---

## 🔧 API Overview

| Property | Description | Required | Default |
|-----------|--------------|-----------|----------|
| `child` | The widget to overlay | ✅ | — |
| `delayDuration` | Delay before the first animation starts | ❌ | 500 ms |
| `useGesture` | Enable user touch control | ❌ | false |
| `borderRadius` | Rounded corners of the overlay | ❌ | 0 |
| `controller` | Custom controller for manual control | ❌ | null |
| `overlayColor` | Color of the lightning overlay | ❌ | white (10% opacity) |
| `pauseDuration` | Delay before reverse animation | ❌ | 200 ms |
| `durationIn` | Duration for appearing animation | ❌ | 300 ms |
| `durationOut` | Duration for disappearing animation | ❌ | 600 ms |
| `curveIn` | Curve for appearing animation | ❌ | `Curves.easeIn` |
| `curveOut` | Curve for disappearing animation | ❌ | `Curves.linear` |
| `direction` | Animation direction | ❌ | `LightningDirection.leftToRight` |
| `repeatInfinity` | Repeats animation infinitely | ❌ | false |
| `pauseRepeatInfinityDelay` | Pause between repeats | ❌ | 2 seconds |
| `autoStart` | Start animation automatically | ❌ | true |

---

## 🧠 Example

```dart
Lightning(
  child: Container(
    width: 200,
    height: 100,
    color: Colors.blue,
    alignment: Alignment.center,
    child: Text('Tap me!', style: TextStyle(color: Colors.white)),
  ),
  overlayColor: Colors.white.withOpacity(0.3),
  useGesture: true,
  borderRadius: 12,
)
```

---

## 📸 Demo

https://github.com/Gastrolize/lightning_overlay/assets/72274345/14377764-7d17-4f6d-a30e-bc1c0a42013a

---

## 🧩 Summary

| Mode | Trigger | Works With Repeat | Use Case |
|------|----------|------------------|-----------|
| Auto | Automatically after delay | ✅ Yes | Simple visual loops |
| Controller | Programmatically | ✅ Yes | Controlled sequences |
| Gesture | User tap | ❌ No | Interactive feedback |

---

## 🪄 Tips

- To make the lightning feel more natural, experiment with:
  - **Shorter `durationIn`** (fast entry)
  - **Longer `durationOut`** (smooth fade)
  - **Low-opacity overlay colors**
- Combine **repeat mode** with different **curves** for unique effects.

---

## 📜 License

MIT License © [Gastrolize](https://github.com/Gastrolize)
