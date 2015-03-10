package;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Lib;

/**
 * ...
 * @author Tiago Ling Alexandre
 */
class Block extends Bitmap implements Updatable
{
	public var otherBlock:Block;
	
	var status:Int = 0;
	var placementOffset:Float;
	
	public function new(bitmapData:BitmapData = null) 
	{
		super(bitmapData);
		
	}
	
	public function init()
	{
		placementOffset = width - 168;
		
		if (Util.isOnScreen(this) && status == 0) {
			status = 1;
		}
	}
	
	public function update()
	{
		switch (status) {
			case 0:
				if (Util.isOnScreen(this)) status = 1;
			case 1:
				if (!Util.isOnScreen(this)) {
					x = otherBlock.x + placementOffset;
					Lib.current.removeChild(this);
					Lib.current.removeChild(otherBlock);
					Lib.current.addChild(this);
					Lib.current.addChild(otherBlock);
				}
		}
	}
	
}