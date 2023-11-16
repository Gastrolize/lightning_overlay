<div id="header" align="center">
  <img src="https://cdn.gastrolize.com/lightning.png" width="300"/>
</div>

# Lightning Overlay
Lightning Overlay for any Widget
Create nice Overlay Effect on any of your Widgets.


https://github.com/Gastrolize/lightning_overlay/assets/72274345/14377764-7d17-4f6d-a30e-bc1c0a42013a


### Modes

It supports following modes:

1. Auto Start with Delay
2. Controlled by the Lightning Controller
3. Gesture

Also it supports following directions:

1. Left Up Corner to Right Bottom Corner
2. Right Bottom Corner to Left Up Corner

### API

| Property        | Description           | Required  |  Optional |
| ------------- |:-------------| :-----:| :---:|
| maxValue      | It depends on the size your child widget. Choose the bigger number. If width=200 and height=300 choose 300.    | `Yes` | No |
| child         | Passing your child widget      |   `Yes` | No |
| delayDuration | When passing delayDuration, the animation will autostart and wait until delayed duration is finished           | No | `Yes` |
| useGesture    | Deciding wether the user can press on it to start the animation and when tap up it finishes the animation      | No | No |
| borderRadius  | If your child widget uses border radius, pass it the double to the Lightning to hide edges on animation        | No | No |
| controller    | To trigger the animation (ex. when clicking on a button)                                                       | No | `Yes` |
| overlayColor  | Styling the overlay color                                                                                      | No | No |
| pauseDuration | When clicking or firing the animation, there can be set a pause Duration between when the overlay fully covered the child and starts to uncover the child  | No | No |
| durationIn    | Duration for the covering animation   | No | No |
| durationOut   | Duration for the uncovering animation   | No | No |
| curveIn       | Curve for the covering animation   | No | No |
| curveOut      | Curve for the uncovering animation   | No | No |
| direction     | Wether the animation goes from left top to right bottom or reverse   | No | No |

### Controller

Create a Controller and pass it to the Lightning Widget:
```flutter
LightningController controller = LightningController();
```

| Function      | Description           |
| ------------- |:-------------|
| animate      | Triggers the overlay animation    |