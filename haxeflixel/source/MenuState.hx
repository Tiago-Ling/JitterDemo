package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var speed:Float = 300;
	var bitmap:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		FlxG.camera.antialiasing = true;
		FlxG.camera.pixelPerfectRender = false;
		this.bgColor = 0xFFFFFFFF;
		
		bitmap = new FlxSprite(FlxG.width / 2 - 50, FlxG.height / 2 - 50, Assets.getBitmapData('assets/images/logo.png'));
		add(bitmap);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		bitmap.x -= elapsed * speed;
		if (bitmap.x + bitmap.width < 0)
			bitmap.x = FlxG.width;
	}
}