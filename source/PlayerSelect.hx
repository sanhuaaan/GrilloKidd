package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.FlxG;

	
class PlayerSelect {
	public var imagen:flixel.FlxSprite;
	private var personajeStr:String;
	private var numPlayer:Int;
	private var stateReference:FlxState;
	public var selector:FlxSprite;
	private var selIndex:Int;
	private var selRow:Int = 0;
	private var nombreTxt:FlxText;
	private var arrayNombres = ["Alex Kidd", "Santo, El Enmascarado de Plata", "Supersonic Man", "Grillo Navajero", "El Loco Ralph", "Astrocholo", "Batman Yeyé", "Vampiro Zombie Chino"];
	private var selectKeyJP:Bool;
	private var leftKey:Bool;
	private var righttKey:Bool;
	private var upKey:Bool;
	private var downKey:Bool;
	private var plElegido:Bool;

	public function new(personaje:String, playerNum:Int, stateRef:flixel.FlxState)
	{		
		numPlayer = playerNum;
		selIndex = (numPlayer == 1)? 0 : 3;
		stateReference = stateRef;
		personajeStr = personaje;
		var sprites = FlxAtlasFrames.fromTexturePackerJson("assets/images/grilloKidd.png", "assets/images/grilloKidd.json");
		imagen = new FlxSprite((numPlayer == 1)? 145 : 620-130-80, 190 + Reg.alturaMap[personajeStr]*3);
		imagen.frames = sprites;

		selector = new FlxSprite((620/2)-(136/2)+34*selIndex, 280);
		selector.loadGraphic("assets/images/selectorPlayer"+numPlayer+".png", true, 32, 32);
		selector.animation.add("activo", [0,1], 6, true);
		selector.animation.play("activo");

		nombreTxt = new FlxText((numPlayer == 1)? -5 : 370, 30);
		nombreTxt.setFormat(null, 24, (numPlayer == 1)? FlxColor.RED : FlxColor.LIME);
		nombreTxt.alignment = FlxTextAlign.CENTER;
		nombreTxt.fieldWidth = 250;
		nombreTxt.setBorderStyle(OUTLINE, FlxColor.PURPLE, 2);
		nombreTxt.text = arrayNombres[selIndex];
		stateReference.add(nombreTxt);

		//No actualiza referencia
		plElegido = (numPlayer == 1)? SelectState.p1Elegido : SelectState.p2Elegido;
	}

	public function addAnimationPiensa(personaje:String):Void
	{
		imagen.animation.addByNames("piensa"+personaje, [personaje+"_piensa01.png",personaje+"_piensa02.png"], 3);
		imagen.scale.set((numPlayer == 1)? 3:-3,3);
		stateReference.add(imagen);
	}

	public function updatePlayer():Void
	{
		selectKeyJP = (numPlayer == 1)? FlxG.keys.justPressed.SPACE : FlxG.keys.justPressed.ENTER;
		leftKey = (numPlayer == 1)? FlxG.keys.justPressed.A : FlxG.keys.justPressed.LEFT;
		righttKey = (numPlayer == 1)? FlxG.keys.justPressed.D : FlxG.keys.justPressed.RIGHT;
		downKey = (numPlayer == 1)? FlxG.keys.justPressed.S : FlxG.keys.justPressed.DOWN;
		upKey = (numPlayer == 1)? FlxG.keys.justPressed.W : FlxG.keys.justPressed.UP;

		if (selectKeyJP)
		{
			if(!SelectState.mapElegidos[Reg.arrayPersonajes[selIndex]])
			{
				FlxG.sound.play("select");
				plElegido = true;
				(numPlayer == 1)? SelectState.p1Elegido = true : SelectState.p2Elegido = true;				
				SelectState.mapElegidos[Reg.arrayPersonajes[selIndex]] = true;
				var elegido:FlxSprite = SelectState.arrayCaras[selIndex];
				elegido.alpha = 0.25;
				selector.visible = false;
			}			
		}			
		if(!plElegido){
			if (righttKey && (selIndex%4)<3)
			{				
				selIndex +=1;	
				checkChanged(1);
			}
			if (leftKey && (selIndex%4)>0)
			{
				selIndex -=1;	
				checkChanged(1);
			}	
			if(downKey && selRow == 0)
			{
				selRow +=1;
				selIndex +=4;
				checkChanged(1);
			}	
			if(upKey && selRow > 0)
			{
				selRow -=1;
				selIndex -=4;
				checkChanged(1);
			}		
		}
	}

	private function checkChanged(player:Int):Void
	{
		nombreTxt.text = arrayNombres[selIndex];
		
		selector.x = (620/2)-(136/2)+34*(selIndex%4);
		selector.y = 280 + (34*selRow);
		(numPlayer == 1)? Reg.P1 = Reg.arrayPersonajes[selIndex] : Reg.P2 = Reg.arrayPersonajes[selIndex];	
		imagen.y = 190 + Reg.alturaMap[Reg.arrayPersonajes[selIndex]]*3;
		imagen.animation.play("piensa"+Reg.arrayPersonajes[selIndex], false, false, imagen.animation.frameIndex);		
	}
}