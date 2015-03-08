package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	public static var SPEED:Float = 500;
	
	var player:FlxSprite;
	var label:FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		FlxG.camera.antialiasing = true;
		FlxG.camera.pixelPerfectRender = false;
		
		//Arbitrary bounds (super big width)
		FlxG.worldBounds.set(0, 0, 128000, 720);
		
		var girderA = new Girder(FlxG.width * 0.5, -180);
		add(girderA);
		
		var girderB = new Girder(FlxG.width * 1.5, -180);
		add(girderB);
		
		var blockA = new Block(0, 300, this);
		var blockB = new Block(1600, 300, this);
		blockA.otherBlock = blockB;
		blockB.otherBlock = blockA;
		blockA.init();
		blockB.init();
		
		add(blockB);
		add(blockA);
		
		player = new FlxSprite(128, 300);
		player.makeGraphic(64, 128, FlxColor.PURPLE);
		player.velocity.set(SPEED, 0);
		add(player);
		
		label = new FlxText(10, 10, 400, 'Speed : ${player.velocity.x}', 16);
		label.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0x333333, 2);
		label.scrollFactor.set(0, 0);
		label.antialiasing = Reg.sprAntialising;
		label.pixelPerfectPosition = Reg.sprPixelPerfectPosition;
		label.pixelPerfectRender = Reg.sprPixelPerfectRender;
		add(label);
		
		FlxG.camera.follow(player, null, null, 1);
		FlxG.camera.deadzone.x = -128;
		FlxG.camera.deadzone.y = 360;
		FlxG.camera.deadzone.width = 300;
		FlxG.camera.deadzone.height = 120;
		FlxG.camera.minScrollY = -92;
		FlxG.camera.maxScrollY = 532;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		handleControls();
		
		label.text = 'Speed : ${player.velocity.x}';
	}
	
	function handleControls()
	{
		if (FlxG.keys.justPressed.DOWN && player.velocity.x > 0) {
			player.velocity.x -= 50;
		}
		
		if (FlxG.keys.justPressed.UP) {
			player.velocity.x += 50;
		}
	}
}