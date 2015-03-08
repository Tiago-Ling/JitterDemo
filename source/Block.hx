package;
import flixel.FlxSprite;
import flixel.FlxState;

/**
 * ...
 * @author Tiago Ling Alexandre
 */
class Block extends FlxSprite
{
	public var otherBlock:Block;
	var status:Int = 0;
	var state:FlxState;
	var placementOffset:Float;
	
	public function new(X:Float, Y:Float, state:FlxState) 
	{
		super(X, Y);
		
		this.state = state;
	}
	
	public function init() 
	{
		loadGraphic(AssetPaths.full_block__png);
		
		antialiasing = Reg.sprAntialising;
		pixelPerfectRender = Reg.sprPixelPerfectRender;
		pixelPerfectPosition = Reg.sprPixelPerfectPosition;
		
		placementOffset = width - 139;
		
		if (isOnScreen() && status == 0) {
			status = 1;
		}
	}
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		switch (status) {
			case 0:
				if (isOnScreen()) status = 1;
			case 1:
				if (!isOnScreen()) {
					x = otherBlock.x + placementOffset;
					state.remove(this);
					state.remove(otherBlock);
					state.add(this);
					state.add(otherBlock);
				}
		}
	}
	
}