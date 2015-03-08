package;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author Tiago Ling Alexandre
 */
class Util
{
	public static var scroll:Float = 0;
	
	//Super-simple screen detection method
	//Works only in x axis for the purposes of this demo
	public static function isOnScreen(obj:DisplayObject):Bool
	{
		return !(obj.x + obj.width < 0 || obj.x > Lib.current.stage.stageWidth);
	}
}