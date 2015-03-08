package;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Lib;

/**
 * ...
 * @author Tiago Ling Alexandre
 */
class Girder extends Bitmap implements Updatable
{
	var status:Int = 0;
	
	public function new(bitmapData:BitmapData) 
	{
		super(bitmapData);
		
		init();
	}
	
	function init()
	{
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
					x = Util.scroll + Lib.current.stage.stageWidth * 1.5;
					status = 0;
				}
		}
	}
}