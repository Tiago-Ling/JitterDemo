# JitterDemo
A set of projects showing jittering in a scrolling image across different Haxe frameworks. The problem occurs in `Cpp` and `Neko` and so far nothing seems to reduce or solve it.

## Usage
Currently there is projects for HaxeFlixel, OpenFL, Lime and NME. The OpenFL test has 3 variants using Bitmap, Tilesheet and OpenGLView. All test cases have a FlashDevelop project which can be run without any problem if the libraries below are installed and properly configured in Haxelib.

## Library Versions
* Haxe - 3.1.3
* Hxcpp - 3.1.68
* Lime - 2.1.3 (Also tried with `master` branch from git (commit `347b25b41d01623d538f914af225c035fc180069`) on both version 2.0 and `-Dlegacy`)
* OpenFL - 2.2.8
* NME - 5.2.43
* HaxeFlixel - Dev (commit f3a01ed368057de717ddb324b665bea9949f694d [f3a01ed])
