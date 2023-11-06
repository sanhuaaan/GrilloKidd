package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

class IntroState extends FlxState{
	

	private var logoGrillero:FlxSprite;
	private var tiempoIntro:Float=2;
	private var _colChangeInterval : Float = 0.05; 
	private var _colChangeTime : Float = 0;
	private var luz:FlxSprite;

	override public function create():Void
	{
		super.create();

		FlxG.mouse.visible = false;

		logoGrillero = new FlxSprite(0, 0);
		logoGrillero.loadGraphic("assets/images/Grillos-navajeros_logo.png");

		logoGrillero.screenCenter();
		logoGrillero.angularVelocity = 1440;
		logoGrillero.scale.x = 0.001;
		logoGrillero.scale.y = 0.001;
		FlxTween.tween(logoGrillero.scale, {x: 0.2, y: 0.2}, tiempoIntro, {type:FlxTween.ONESHOT, onComplete:function(_)
		{
			logoGrillero.angularVelocity = 0;
			FlxTween.tween(logoGrillero.scale, {x: 0.3, y: 0.3},0.1,{type:FlxTween.PINGPONG});
			luz.visible = true;
			FlxTween.tween(luz,{alpha:0},0.2,{type:FlxTween.ONESHOT});
			FlxG.camera.shake(0.02,2.5);
		}});

		luz = new FlxSprite(0, 0);
		luz.makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
		luz.visible = false;
		//add(luz);

		add(logoGrillero);
		FlxG.sound.play("intro");

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_colChangeTime -= FlxG.elapsed; 
        if (_colChangeTime <= 0) 
        {
                logoGrillero.color = (logoGrillero.color == FlxColor.RED)? FlxColor.LIME : FlxColor.RED;
                _colChangeTime += _colChangeInterval;
                if(logoGrillero.angularVelocity == 0)logoGrillero.angle = FlxG.random.int(-15, 15);
        }
		
		new FlxTimer().start(tiempoIntro+2.5,function(_){FlxG.switchState(new MenuState());});
	}
}
