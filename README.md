# OPLGaugeView

A speedomter built with Swift that can be used to track the speed of travel. 

## Installing

```
$pod install OPLGaugeView
```

or in your Podfile

```
pod 'OPLGaugeView'
```

or include the files OPLGaugeView and OPLGaugeLayer in your project.

## Usage

Subclass a UIView with OPLGaugeView or instantiate an OPLGaugeView in code.

## Config

OPLGaugeView allows you to set some parameters.

```
//Add spring animation to gauge rotation
self.gaugeView.enableSpring = true

//Disable spring animtion from gauge rotation
self.gaugeView.enableSpring = false

//rotate the gauge to a new speed
let speed: CGFloat = 25
self.gaugeView.rotateGauge(newSpeed: 25)
```

## Example

An example project is included which shows how to use OPLGaugeView with Core Location to get the speed of walking or running.

## Author

**Gwinyai Nyatsoka** [Gwinyai](https://github.com/Gwinyai)

## LICENSE

This project is licensed under the MIT License - see [LICENSE](LICENSE.md) for more details



