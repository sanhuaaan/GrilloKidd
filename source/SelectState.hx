package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flash.system.System;


class SelectState extends FlxState 
{
	public static var arrayCaras = [];
	public static var mapElegidos:Map<String, Bool>;
	public static var p1Elegido:Bool;
	public static var p2Elegido:Bool;
	private var loop:FlxSound;
	private var P1:PlayerSelect;
	private var P2:PlayerSelect;

	override public function create():Void
	{		
		super.create();

		mapElegidos = ["Alex"=>false, "Santo"=>false, "Supersonic"=>false, "Grillo"=>false, "Ralph"=>false, "Astrocholo"=>false, "Batman"=>false, "Vampiro"=>false];
		p1Elegido = p2Elegido = false;
		var i = 0;
		
		P1 = new PlayerSelect(Reg.P1, 1, this);
		P2 = new PlayerSelect(Reg.P2, 2, this);
		Reg.P1 = "Alex";
		Reg.P2 = "Grillo";

		var j:Int=0;
		for (cara in 0...Reg.arrayPersonajes.length) {
			var face = new FlxSprite((620/2)-(136/2)+34*(i%4), 280 + (34*j), "assets/images/"+Reg.arrayPersonajes[cara]+"_cara.png");			
			P1.addAnimationPiensa(Reg.arrayPersonajes[cara]);
			P2.addAnimationPiensa(Reg.arrayPersonajes[cara]);
			add(face);
			arrayCaras.insert(i, face);
			i++;
			if(i==4)
				j+=1;
		}	
		P1.imagen.animation.play("piensa"+Reg.P1);
		add(P1.selector);
		P2.imagen.animation.play("piensa"+Reg.P2);
		add(P2.selector);	
		
		loop = new FlxSound();
		loop.loadEmbedded("selectLoop");
		loop.looped = true;
		loop.play();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) System.exit(0);

		P1.updatePlayer();		
		P2.updatePlayer();	

		if(p1Elegido && p2Elegido) 
			new FlxTimer().start(1, function(_){
				loop.stop();
				FlxG.switchState(new PlayState());
			});	
		
	}	
}