package;
import openfl.Assets;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

/**
 * Scrolling jittering demo using Bitmap class
 * @author Tiago Ling Alexandre
 */
class BitmapDemo extends Sprite
{
	var useDelta:Bool = true;
	var speed:Float = 300;
	//Factor is used if 'useDelta' is false
	var factor:Float = 0.02;
	
	var bmps:Array<Updatable>;
	var ticks:Int;
	var elapsedMS:Int;
	var total:Int;
	var elapsedSecs:Float;
	
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
		
		var girderA = new Girder(Assets.getBitmapData('assets/images/jitter_spr_narrow.png'));
		girderA.x = Lib.current.stage.stageWidth * 0.5;
		girderA.y = 350;
		addChild(girderA);
		
		var girderB = new Girder(Assets.getBitmapData('assets/images/jitter_spr_small.png'));
		girderB.x = Lib.current.stage.stageWidth * 1.5;
		girderB.y = 350;
		addChild(girderB);
		
		var blockA = new Block(Assets.getBitmapData('assets/images/block_b.png'));
		blockA.x = 0;
		blockA.y = 500;
		
		var blockB = new Block(Assets.getBitmapData('assets/images/block_b.png'));
		blockB.x = 1590;
		blockB.y = 500;
		
		bmps = new Array<Updatable>();
		bmps.push(girderA);
		bmps.push(girderB);
		bmps.push(blockA);
		bmps.push(blockB);
		
		blockA.otherBlock = blockB;
		blockB.otherBlock = blockA;
		blockA.init();
		blockB.init();
		
		addChild(blockB);
		addChild(blockA);
		
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
				for (bmp in bmps) bmp = null;
				bmps = null;
				
				Lib.current.addChild(new Menu());
		}
	}
	
	function update(e:Event)
	{
		if (useDelta) {
			ticks = Lib.getTimer();
			elapsedMS = ticks - total;
			elapsedSecs = elapsedMS / 1000;
			
			Util.scroll += elapsedSecs;
			
			for (obj in bmps) {
				obj.update();
				
				obj.x -= elapsedSecs * speed;
			}
			
			total = ticks;
		} else {
			
			Util.scroll += factor;
			
			for (obj in bmps) {
				obj.update();
				
				obj.x -= factor * speed;
			}
		}
	}
}