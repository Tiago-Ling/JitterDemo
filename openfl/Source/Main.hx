package;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

/**
 * Scrolling jittering demo
 * @author Tiago Ling Alexandre
 */
class Main extends Sprite {
	
	public function new () {
		
		super ();
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		#if flash
		Lib.current.addChild(new BitmapDemo());
		#else
		Lib.current.addChild(new Menu());
		#end
	}
	

}