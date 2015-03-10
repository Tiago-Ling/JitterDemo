# JitterDemo
Simpler demo showing the jitter / "blur" problem in HaxeFlixel's and/or OpenFL rendering.

## Controls 

* `Up` key - Increases speed
* `Down` key - Decreases speed
* `Space` key - Toggle usage of delta time (OpenFL only)
* `Page Up` key - Increases position factor (OpenFL only)
* `Page Down` key - Decreases position factor (OpenFL only)

## Usage
There is one project using HaxeFlixel and another using OpenFL, both are inside folders with these respective names. The OpenFL project has demos showing the scrolling problem using `Bitmap`, `Tilesheet` and `OpenGLView` classes.

To better visualize the problem images with parallel vertical lines are used. Change `speed`, `useDelta` and `factor` values to see the jittering in different intensities.

## Library Versions

* Haxe - 3.1.3
* Hxcpp - 3.1.68
* Lime - 2.1.3
* OpenFL - 2.2.8
* HaxeFlixel - Dev (commit f3a01ed368057de717ddb324b665bea9949f694d [f3a01ed])
