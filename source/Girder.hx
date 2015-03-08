package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

/**
 * ...
 * @author Tiago Ling Alexandre
 */
class Girder extends FlxSprite
{
	var status:Int = 0;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		
		init();
	}
	
	public function init() 
	{
		loadGraphic(AssetPaths.girder__png);
		
		antialiasing = Reg.sprAntialising;
		pixelPerfectRender = Reg.sprPixelPerfectRender;
		pixelPerfectPosition = Reg.sprPixelPerfectPosition;
		
		if (isOnScreen() && status == 0) {
			status = 1;
		}
	}
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		switch (status) {
			case 0:
				if (isOnScreen()) status = 1;
			case 1:
				if (!isOnScreen()) {
					x = FlxG.camera.scroll.x + FlxG.width * 1.5;
					status = 0;
				}
		}
	}
	
}