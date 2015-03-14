
import luxe.Input;
import luxe.Sprite;
import luxe.Vector;

class Main extends luxe.Game {

	var sprite:Sprite;
	var speed:Float = 400;
	var posX:Float;

    override function ready() {

       sprite = new Sprite({
            name:'example',
            texture : Luxe.loadTexture('assets/logo.png'),
            pos : Luxe.screen.mid,
            centered : false,
            flipx:true,
            flipy:true
        });

       posX = sprite.pos.x;
    } //ready

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(dt:Float) {

    	trace('dt : $dt');
    	
		if (sprite.pos.x + sprite.size.x > 0)
			posX -= dt * speed;
		else
			posX = Luxe.screen.w;

		sprite.pos.x = Std.int(posX);
    } //update


} //Main
