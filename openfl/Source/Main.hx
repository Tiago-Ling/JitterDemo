package;


import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;


class Main extends Sprite {
	
	var speed:Float = 300;
	
	var bmps:Array<Updatable>;
	var ticks:Int;
	var elapsedMS:Int;
	var total:Int;
	var elapsedSecs:Float;
	
	var label:TextField;
	
	public function new () {
		
		super ();
		
		ticks = 0;
		elapsedMS = 0;
		elapsedSecs = 0;
		total = Lib.getTimer();
		
		var girderA = new Girder(Assets.getBitmapData('assets/images/girder.png'));
		girderA.x = Lib.current.stage.stageWidth * 0.5;
		addChild(girderA);
		
		var girderB = new Girder(Assets.getBitmapData('assets/images/girder.png'));
		girderB.x = Lib.current.stage.stageWidth * 1.5;
		addChild(girderB);
		
		var blockA = new Block(Assets.getBitmapData('assets/images/full_block.png'));
		blockA.x = 0;
		blockA.y = 500;
		
		var blockB = new Block(Assets.getBitmapData('assets/images/full_block.png'));
		blockB.x = 1600;
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
		label.defaultTextFormat = new TextFormat('Arial', 16, 0xFFFFFF);
		label.text = 'Speed : $speed';
		addChild(label);
		
		addEventListener(Event.ENTER_FRAME, update);
		stage.addEventListener(KeyboardEvent.KEY_UP, handleControls);
	}
	
	private function handleControls(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.UP:
				speed += 50;
				label.text = 'Speed : $speed';
			case Keyboard.DOWN:
				if (speed > 0)
					speed -= 50;
				label.text = 'Speed : $speed';
		}
	}
	
	function update(e:Event)
	{
		ticks = Lib.getTimer();
		elapsedMS = ticks - total;
		elapsedSecs = elapsedMS / 1000;
		total = ticks;
		
		//Util.scroll += elapsedSecs;
		
		//Testing with hardcoded fixed value
		Util.scroll += 0.022;
		
		for (obj in bmps) {
			obj.update();
			
			//obj.x -= elapsedSecs * speed;
			
			//Testing with hardcoded fixed value
			obj.x -= 0.022 * speed;
		}
		
	}
}