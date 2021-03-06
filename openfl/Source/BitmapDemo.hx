package;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

@:bitmap('Assets/images/openfl.png') class Logo extends flash.display.BitmapData {}
/**
 * Scrolling jittering demo using Bitmap class
 * @author Tiago Ling Alexandre
 */
class BitmapDemo extends Sprite
{
	var bitmap:Bitmap;
	var speed:Float = 300.0;
	var lastTicks:Float = 0.0;
	var posX:Float;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED, init);
	}
	
	function init(e:Event)
	{
		removeEventListener(Event.ADDED, init);
		
		bitmap = new Bitmap(new Logo(400, 400));
		addChild(bitmap);
		
		bitmap.x = (Lib.current.stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (Lib.current.stage.stageHeight - bitmap.height) / 2;
		
		posX = bitmap.x;
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update(e:Event)
	{
        var ticks:Float = haxe.Timer.stamp() * 1000.0;
        var delta:Float = (ticks - lastTicks); // Float delta
			
		if (bitmap.x + bitmap.width > 0)
			posX -= (delta / 1000) * speed;
		else
			posX = stage.stageWidth;
        
		bitmap.x = Std.int(posX);
		
        lastTicks = ticks;
	}
}