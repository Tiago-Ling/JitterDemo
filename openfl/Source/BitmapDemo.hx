package;
import flash.display.Bitmap;
import openfl.Assets;
import flash.display.Sprite;
import flash.events.Event;
import openfl.Lib;

/**
 * Scrolling jittering demo using Bitmap class
 * @author Tiago Ling Alexandre
 */
class BitmapDemo extends Sprite
{
	var bitmap:Bitmap;
	var speed:Float = 300.0;
	var lastTicks:Float = 0.0;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED, init);
	}
	
	function init(e:Event)
	{
		removeEventListener(Event.ADDED, init);
		
		bitmap = new Bitmap(Assets.getBitmapData('assets/images/openfl.png'));
		addChild(bitmap);
		
		bitmap.x = (Lib.current.stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (Lib.current.stage.stageHeight - bitmap.height) / 2;
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update(e:Event)
	{
        var ticks:Float = haxe.Timer.stamp() * 1000.0;
        var delta:Float = (ticks - lastTicks); // Float delta
        
		bitmap.x -= (delta / 1000) * speed;
		if (bitmap.x + bitmap.width < 0)
			bitmap.x = stage.stageWidth;
        
        lastTicks = ticks;
	}
}