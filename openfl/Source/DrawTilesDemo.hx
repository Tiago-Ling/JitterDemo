package;
import openfl.Assets;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

/**
 * Scrolling jittering demo using Tilesheet class (drawTiles)
 * @author Tiago Ling Alexandre
 */
class DrawTilesDemo extends Sprite
{
	var speed:Float = 300.0;
	var lastTicks:Float = 0.0;
	
	var position:Point;
	var ts:Tilesheet;
	var container:Sprite;
	var tiles:Array<Float>;
	
	var tileRect:Rectangle;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED, init);
	}
	
	function init(e:Event)
	{
		removeEventListener(Event.ADDED, init);
		
		ts = new Tilesheet(Assets.getBitmapData('assets/images/openfl.png'));
		tileRect = new Rectangle(0, 0, 400, 400);
		ts.addTileRect(tileRect);
		
		container = new Sprite();
		addChild(container);
		
		position = new Point(Lib.current.stage.stageWidth / 2 - 200, Lib.current.stage.stageHeight / 2 - 200);
		
		tiles = [position.x, position.y, 0, 1, 0, 0, 1];
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update(e:Event)
	{
        var ticks:Float = haxe.Timer.stamp() * 1000.0;
        var delta:Float = (ticks - lastTicks); // Float delta
        
		position.x -= (delta / 1000) * speed;
		if (position.x + tileRect.width < 0)
			position.x = stage.stageWidth;
        
        lastTicks = ticks;
		
		tiles[0] = position.x;
		container.graphics.clear();
		ts.drawTiles(container.graphics, tiles, true, Tilesheet.TILE_TRANS_2x2);
	}
	
}