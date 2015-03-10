package;


import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.ui.Keyboard;

/**
 * Scrolling jittering demo
 * @author Tiago Ling Alexandre
 */
class Main extends Sprite {
	
	public function new () {
		
		super ();
		
		addEventListener(Event.ADDED, init);
	}
	
	private function init(e:Event):Void 
	{
		removeEventListener(Event.ADDED, init);
		
		Lib.current.addChild(new Menu());
	}
	

}