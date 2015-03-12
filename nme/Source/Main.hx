import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.Lib;


class Main extends Sprite {
	
	var bitmap:Bitmap;
	var speed:Float = 300.0;
	var lastTicks:Float = 0.0;
	
	public function new () {
		
		super ();
		
		bitmap = new Bitmap (Assets.getBitmapData ("assets/nme.png"));
		addChild (bitmap);
		
/*		bitmap.x = Lib.current.stage.stageWidth - bitmap.width;
		bitmap.y = Lib.current.stage.stageHeight - bitmap.height;
		
		motion.Actuate.tween(bitmap, 5, { x:0 } ).ease(motion.easing.Linear.easeNone).repeat().reflect();*/
		
		bitmap.x = (Lib.current.stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (Lib.current.stage.stageHeight - bitmap.height) / 2;
		
		addEventListener(nme.events.Event.ENTER_FRAME, update);
	}
	
	function update(e:nme.events.Event) {
		
        var ticks:Float = haxe.Timer.stamp() * 1000.0;
        var delta:Float = (ticks - lastTicks); // Float delta
        
		bitmap.x -= (delta / 1000) * speed;
		if (bitmap.x + bitmap.width < 0)
			bitmap.x = stage.stageWidth;
        
        lastTicks = ticks;
		
		//trace('delta : $delta');
	}
}