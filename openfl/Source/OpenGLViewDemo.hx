package;


import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;
import openfl.display.FPS;
import openfl.display.OpenGLView;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLTexture;
import openfl.gl.GLUniformLocation;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;
import openfl.Assets;

/**
 * Scrolling jittering demo using OpenGLView class
 * Minimally adapted from the OpenFL sample 'SimpleOpenGLView'
 */
class OpenGLViewDemo extends Sprite {
	
	private var bitmapData:BitmapData;
	private var imageUniform:GLUniformLocation;
	private var modelViewMatrixUniform:GLUniformLocation;
	private var projectionMatrixUniform:GLUniformLocation;
	private var shaderProgram:GLProgram;
	private var texCoordAttribute:Int;
	private var texCoordBuffer:GLBuffer;
	private var texture:GLTexture;
	private var view:OpenGLView;
	private var vertexAttribute:Int;
	private var vertexBuffer:GLBuffer;
	
	var positionX:Float;
	var positionY:Float;
	
	var useDelta:Bool = true;
	var speed:Float = 300;
	//Factor is used if 'useDelta' is false
	var factor:Float = 0.02;
	
	var label:TextField;
	
	var ticks:Int;
	var elapsedMS:Int;
	var total:Int;
	var elapsedSecs:Float;
	
	public function new () {
		
		super();
		
		addEventListener(Event.ADDED, init);
	}
	
	function init(e:Event)
	{
		removeEventListener(Event.ADDED, init);
		
		ticks = 0;
		elapsedMS = 0;
		elapsedSecs = 0;
		total = Lib.getTimer();
		
		bitmapData = Assets.getBitmapData ("assets/images/sample_image.png");
		
		if (OpenGLView.isSupported) {
			
			view = new OpenGLView ();
			
			initializeShaders ();
			
			createBuffers ();
			createTexture ();
			
			positionX = (stage.stageWidth - bitmapData.width) / 2;
			positionY = (stage.stageHeight - bitmapData.height) / 2;
			
			view.render = renderView;
			addChild (view);
			
			label = new TextField();
			label.x = label.y = 10;
			label.width = 400;
			label.defaultTextFormat = new TextFormat('Arial', 16, 0xFFFFFF);
			label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			addChild(label);
		
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, handleControls);
			
			addChild(new FPS(10, 50, 0xFFFFFF));
		}
	}
	
	private function handleControls(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.UP:
				speed += 50;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.DOWN:
				if (speed > 0)
					speed -= 50;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.SPACE:
				useDelta = !useDelta;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.PAGE_UP:
				factor += 0.01;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.PAGE_DOWN:
				factor -= 0.01;
				label.text = 'Speed : $speed | useDelta : $useDelta | factor : $factor';
			case Keyboard.ESCAPE:
				Lib.current.removeChild(this);
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, handleControls);
				label = null;
				bitmapData = null;
				imageUniform = null;
				modelViewMatrixUniform = null;
				projectionMatrixUniform = null;
				shaderProgram = null;
				texCoordBuffer = null;
				texture = null;
				view.render = null;
				view = null;
				vertexBuffer = null;
				Lib.current.addChild(new Menu());
		}
	}
	
	private function createBuffers ():Void {
		
		var vertices = [
			
			bitmapData.width, bitmapData.height, 0,
			0, bitmapData.height, 0,
			bitmapData.width, 0, 0,
			0, 0, 0
			
		];
		
		vertexBuffer = GL.createBuffer ();
		GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
		GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast vertices), GL.STATIC_DRAW);
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		
		var texCoords = [
			
			1, 1, 
			0, 1, 
			1, 0, 
			0, 0, 
			
		];
		
		texCoordBuffer = GL.createBuffer ();
		GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);	
		GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast texCoords), GL.STATIC_DRAW);
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		
	}
	
	
	private function createTexture ():Void {
		
		#if html5
		var pixelData = bitmapData.getPixels (bitmapData.rect).byteView;
		#else
		var pixelData = new UInt8Array (bitmapData.getPixels (bitmapData.rect));
		#end
		
		texture = GL.createTexture ();
		GL.bindTexture (GL.TEXTURE_2D, texture);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		GL.texImage2D (GL.TEXTURE_2D, 0, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixelData);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
		GL.bindTexture (GL.TEXTURE_2D, null);
		
	}
	
	
	private function initializeShaders ():Void {
		
		var vertexShaderSource = 
			
			"attribute vec3 aVertexPosition;
			attribute vec2 aTexCoord;
			varying vec2 vTexCoord;
			
			uniform mat4 uModelViewMatrix;
			uniform mat4 uProjectionMatrix;
			
			void main(void) {
				vTexCoord = aTexCoord;
				gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 1.0);
			}";
		
		var vertexShader = GL.createShader (GL.VERTEX_SHADER);
		GL.shaderSource (vertexShader, vertexShaderSource);
		GL.compileShader (vertexShader);
		
		if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) {
			
			throw "Error compiling vertex shader";
			
		}
		
		var fragmentShaderSource = 
			
			#if !desktop
			"precision mediump float;" +
			#end
			"varying vec2 vTexCoord;
			uniform sampler2D uImage0;
			
			void main(void)
			{" + 
			#if ((openfl < "3.0.0") && !openfl_next && !html5)
				"gl_FragColor = texture2D (uImage0, vTexCoord).gbar;" + 
			#else
				"gl_FragColor = texture2D (uImage0, vTexCoord);" + 
			#end
			"}";
		
		var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
		GL.shaderSource (fragmentShader, fragmentShaderSource);
		GL.compileShader (fragmentShader);
		
		if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {
			
			throw "Error compiling fragment shader";
			
		}
		
		shaderProgram = GL.createProgram ();
		GL.attachShader (shaderProgram, vertexShader);
		GL.attachShader (shaderProgram, fragmentShader);
		GL.linkProgram (shaderProgram);
		
		if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) {
			
			throw "Unable to initialize the shader program.";
			
		}
		
		vertexAttribute = GL.getAttribLocation (shaderProgram, "aVertexPosition");
		texCoordAttribute = GL.getAttribLocation (shaderProgram, "aTexCoord");
		projectionMatrixUniform = GL.getUniformLocation (shaderProgram, "uProjectionMatrix");
		modelViewMatrixUniform = GL.getUniformLocation (shaderProgram, "uModelViewMatrix");
		imageUniform = GL.getUniformLocation (shaderProgram, "uImage0");
		
	}
	
	
	private function renderView (rect:Rectangle):Void {
		
		if (useDelta) {
			ticks = Lib.getTimer();
			elapsedMS = ticks - total;
			elapsedSecs = elapsedMS / 1000;
			
			positionX -= elapsedSecs * speed;
			if (positionX + bitmapData.width < 0)
				positionX = stage.stageWidth;
			
			total = ticks;
		} else {	
			positionX -= factor * speed;
			if (positionX + bitmapData.width < 0)
				positionX = stage.stageWidth;
		}
			
		GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
		
		GL.clearColor (0, 0, 0, 1.0);
		GL.clear (GL.COLOR_BUFFER_BIT);
		
		var projectionMatrix = Matrix3D.createOrtho (0, rect.width, rect.height, 0, 1000, -1000);
		var modelViewMatrix = Matrix3D.create2D (positionX, positionY, 1, 0);
		
		GL.useProgram (shaderProgram);
		GL.enableVertexAttribArray (vertexAttribute);
		GL.enableVertexAttribArray (texCoordAttribute);
		
		GL.activeTexture (GL.TEXTURE0);
		GL.bindTexture (GL.TEXTURE_2D, texture);
		
		#if desktop
		GL.enable (GL.TEXTURE_2D);
		#end
		
		GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
		GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 0, 0);
		GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
		GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 0, 0);
		
		GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.rawData));
		GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
		GL.uniform1i (imageUniform, 0);
		
		GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
		
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		GL.bindTexture (GL.TEXTURE_2D, null);
		
		#if desktop
		GL.disable (GL.TEXTURE_2D);
		#end
		
		GL.disableVertexAttribArray (vertexAttribute);
		GL.disableVertexAttribArray (texCoordAttribute);
		GL.useProgram (null);
		
	}
}