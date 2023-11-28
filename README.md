<div id="header" align="center">
  <img src="https://cdn.gastrolize.com/lightning.png" width="300"/>
</div>

# Lightning Overlay
Lightning Overlay for any Widget
Create nice Overlay Effect on any of your Widgets.


https://github.com/Gastrolize/lightning_overlay/assets/72274345/14377764-7d17-4f6d-a30e-bc1c0a42013a


### Note

* If you want to use the Auto Start, you need to set `delayDuration`. Also you need to set a `pauseDuration` for the reverse animation. If the reverse animation not starts, you need to increase the `pauseDuration`.
* If you want to use Repeat Mode, set a higher Pause Delay `pauseRepeatDelay` (default 2 Seconds), because if the animation is finished, the `pauseRepeatDelay` will be triggered and the animation will be replay.


### Modes

It supports following modes:

1. Auto Start with Delay
2. Controlled by the Lightning Controller
3. Gesture
4. Repeat

Also it supports following directions:

1. Left Up Corner to Right Bottom Corner
2. Right Bottom Corner to Left Up Corner


### API

| Property        | Description                                                                                                                                                                                                   | Required  |  Optional |
| ------------- |:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| :-----:| :---:|
| maxValue      | It depends on the size of your child widget. Choose the bigger number. If width=200 and height=300 choose 300.                                                                                                | `Yes` | No |
| child         | Passing your child widget                                                                                                                                                                                     |   `Yes` | No |
| delayDuration | When passing delayDuration, the animation will autostart after delayed duration                                                                                                                               | No | `Yes` |
| useGesture    | Deciding wether the user can press on it to start the animation and when press ends it finishes the animation                                                                                                 | No | No |
| borderRadius  | If your child widget uses border radius, pass the radius to the Lightning Widget to hide edges on animation                                                                                                   | No | No |
| controller    | To trigger the animation (ex. when clicking on a button)                                                                                                                                                      | No | `Yes` |
| overlayColor  | Styling the overlay color                                                                                                                                                                                     | No | No |
| pauseDuration | When clicking or firing the animation, there can be set a pause Duration between when the overlay fully covered the child and starts to uncover the child.                                                    | No | No |
| durationIn    | Duration for the covering animation                                                                                                                                                                           | No | No |
| durationOut   | Duration for the uncovering animation                                                                                                                                                                         | No | No |
| curveIn       | Curve for the covering animation                                                                                                                                                                              | No | No |
| curveOut      | Curve for the uncovering animation                                                                                                                                                                            | No | No |
| direction     | Wether the animation goes from left top to right bottom or reverse                                                                                                                                            | No | No |

### Controller

Create a Controller and pass it to the Lightning Widget:
```flutter
LightningController controller = LightningController();
```

Notice: You need to wait between the animateIn and animateOut, because the animateIn need's to finish the covering animation until animateOut can be called.

| Function   | Description                       |
|------------|:----------------------------------|
| animateIn  | Triggers the covering animation   |
| animateOut | Triggers the uncovering animation |