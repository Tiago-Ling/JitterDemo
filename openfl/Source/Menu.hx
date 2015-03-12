package;
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
class Menu extends Sprite
{
	var label:TextField;
	var title:TextField;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED, init);
	}
	
	private function init(e:Event):Void 
	{
		removeEventListener(Event.ADDED, init);
		
		title = new TextField();
		title.y = 100;
		title.width = stage.stageWidth;
		title.defaultTextFormat = new TextFormat('Arial', 22, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER);
		title.text = 'OpenFL Jittering demo';
		addChild(title);
		
		label = new TextField();
		label.y = 250;
		label.width = stage.stageWidth;
		label.defaultTextFormat = new TextFormat('Arial', 16, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER);
		label.text = 'Press [E] to run Bitmap demo\n\nPress [R] to run DrawTiles demo\n\nPress [T] to run OpenGLView demo';
		addChild(label);
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, handleControls);
	}
	
	private function handleControls(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.E:
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, handleControls);
				Lib.current.removeChild(this);
				title = null;
				label = null;
				Lib.current.addChild(new BitmapDemo());
			case Keyboard.R:
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, handleControls);
				Lib.current.removeChild(this);
				title = null;
				label = null;
				Lib.current.addChild(new DrawTilesDemo());
			case Keyboard.T:
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, handleControls);
				Lib.current.removeChild(this);
				title = null;
				label = null;
				Lib.current.addChild(new OpenGLViewDemo());
		}
	}
}