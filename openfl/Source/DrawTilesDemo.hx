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
	var useDelta:Bool = true;
	var speed:Float = 300;
	//Factor is used if 'useDelta' is false
	var factor:Float = 0.02;
	
	var ticks:Int;
	var elapsedMS:Int;
	var total:Int;
	var elapsedSecs:Float;
	
	var positions:Array<Point>;
	var ts:Tilesheet;
	var container:Sprite;
	var tiles:Array<Float>;
	var refSizes:Array<Int>;
	
	var label:TextField;

	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED, init);
	}
	
	function init(e:Event)
	{
		removeEventListener(Event.ADDED, init);
		
		ticks = 0;
		elapsedMS = 0;
		elapsedSecs = 0;
		total = Lib.getTimer();
		
		ts = new Tilesheet(Assets.getBitmapData('assets/images/jitter_atlas.png'));
		
		//Block A
		ts.addTileRect(new Rectangle(1, 1, 1759, 479));
		//Girder
		ts.addTileRect(new Rectangle(1761, 1, 147, 696));
		//Blue square
		ts.addTileRect(new Rectangle(1909, 1, 129, 129));
		//Green square
		ts.addTileRect(new Rectangle(1, 913, 66, 66));
		//Yellow square
		ts.addTileRect(new Rectangle(68, 913, 44, 64));
		//Block B
		ts.addTileRect(new Rectangle(1, 481, 1739, 431));
		
		container = new Sprite();
		addChild(container);
		
		positions = new Array<Point>();
		positions[0] = new Point(0, 500);
		positions[1] = new Point(1600, 500);
		positions[2] = new Point(Lib.current.stage.stageWidth * 0.75, 100);
		positions[3] = new Point(Lib.current.stage.stageWidth * 1.25, 100);
		positions[4] = new Point(Lib.current.stage.stageWidth * 0.5, 350);
		positions[5] = new Point(Lib.current.stage.stageWidth * 1.5, 350);
		
		var indices = new Array<Float>();
		indices[0] = 0;
		indices[1] = 0;
		indices[2] = 1;
		indices[3] = 1;
		indices[4] = 3;
		indices[5] = 4;
		
		refSizes = new Array<Int>();
		refSizes[0] = 1600;
		refSizes[1] = 1600;
		refSizes[2] = 147;
		refSizes[3] = 147;
		refSizes[4] = 66;
		refSizes[5] = 44;
		
		tiles = new Array<Float>();
		for (i in 0...indices.length) {
			var p = i * 7;
			tiles[p] = positions[i].x;
			tiles[p + 1] = positions[i].y;
			tiles[p + 2] = indices[i];
			tiles[p + 3] = 1;
			tiles[p + 4] = 0;
			tiles[p + 5] = 0;
			tiles[p + 6] = 1;
		}
		
		label = new TextField();
		label.x = label.y = 10;
		label.width = 400;
		label.defaultTextFormat = new TextFormat('Arial', 16, 0xFFFFFF);
		label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
		addChild(label);
		
		addEventListener(Event.ENTER_FRAME, update);
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, handleControls);
		addChild(new FPS(10, 50, 0xFFFFFF));
	}
	
	private function handleControls(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.UP:
				speed += 50;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.DOWN:
				if (speed > 0)
					speed -= 50;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.SPACE:
				useDelta = !useDelta;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.PAGE_UP:
				factor += 0.01;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.PAGE_DOWN:
				factor -= 0.01;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.ESCAPE:
				Lib.current.removeChild(this);
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, handleControls);
				removeEventListener(Event.ENTER_FRAME, update);
				label = null;
				ts = null;
				container = null;
				tiles = null;
				refSizes = null;
				for (pos in positions) pos = null;
				positions = null;
				
				Lib.current.addChild(new Menu());
		}
	}
	
	function update(e:Event)
	{
		if (useDelta) {
			ticks = Lib.getTimer();
			elapsedMS = ticks - total;
			elapsedSecs = elapsedMS / 1000;
			
			for (i in 0...positions.length) {
				
				var pos = positions[i];
				pos.x -= elapsedSecs * speed;
				
				if (pos.x + refSizes[i] < 0)
					pos.x += stage.stageWidth + refSizes[i];
					
				tiles[i * 7] = pos.x;
			}
			
			total = ticks;
		} else {
			for (i in 0...positions.length) {
				
				var pos = positions[i];
				pos.x -= factor * speed;
				
				if (pos.x + refSizes[i] < 0)
					pos.x += stage.stageWidth + refSizes[i];
					
				tiles[i * 7] = pos.x;
			}
		}
		
		container.graphics.clear();
		ts.drawTiles(container.graphics, tiles, true, Tilesheet.TILE_TRANS_2x2);
	}
	
}