package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;


import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flash.system.System;

class MenuState extends FlxState
{

	private var _blinkInterval : Float = 0.3; 
	private var _blinkTime : Float = 0; 
	private var startTxt:FlxText;
	private var theme:FlxSound;

	override public function create():Void
	{
		super.create();			
		

		var inicio:FlxSprite = new FlxSprite(0, 0);
		inicio.frames = FlxAtlasFrames.fromTexturePackerJson("assets/images/gifInicio.png", "assets/images/gifInicio.json");
		var namesAnim = [];
		
		inicio.animation.addByNames("anim", 
			["target-0.png",
			"target-1.png",
			"target-2.png",
			"target-3.png",
			"target-4.png",
			"target-5.png",
			"target-6.png",
			"target-7.png",
			"target-8.png",
			"target-9.png",], 2);
		inicio.animation.play("anim");
		add(inicio);

		
		startTxt = new FlxText(0, 340, 0, "Pulsa cualquier tecla para empezar", 100);
		startTxt.alignment = FlxTextAlign.CENTER;
		startTxt.fieldWidth = FlxG.width;
		startTxt.setFormat(null, 16, FlxColor.YELLOW);
		add(startTxt);
		
		theme = new FlxSound();
		theme.loadEmbedded("main");
		theme.looped = true;
		theme.play();


		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) System.exit(0);

		_blinkTime -= FlxG.elapsed; 
        if (_blinkTime <= 0) 
        {
                startTxt.visible = !startTxt.visible; 
                _blinkTime += _blinkInterval; 
        }

		if (FlxG.keys.justPressed.ANY)
		{	
			if(theme.playing){				
				theme.stop();
				FlxG.sound.play("yeah");
				_blinkTime=0;
				_blinkInterval=0.07;
				new FlxTimer().start(1,function(_){FlxG.switchState(new SelectState());});	
			}		
			
		}			 
	}
}
