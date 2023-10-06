package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flash.system.System;


class PlayState extends FlxState
{
	private var P1Score:Int=0;
	private var P1TxtScore:FlxText;
	private var P2Score:Int=0;
	private var P2TxtScore:FlxText;
	private var resultadoRonda:FlxText;

	private var HandsMap:Map<Int, String> = [0=>"piedra", 1=>"tijera", 2=>"papel", 3=>"grillo", 4=>"navaja"];
	private var resultadoTxtMap:Map<String, String> = [
													"pi-pa"=>"El papel envuelve la piedra", 
													"pi-ti"=>"La piedra destroza la tijera", 
													"pi-gr"=>"La piedra aplasta al grillo", 
													"pi-nv"=>"La navaja se afila en la piedra", 
													"pa-ti"=>"La tijera corta el papel", 
													"pa-gr"=>"El grillo se come el papel", 
													"pa-nv"=>"El papel atasca la navaja", 
													"ti-gr"=>"Las tijeras cortan al grillo", 
													"ti-nv"=>"La navaja desmonta la tijera", 
													"gr-nv"=>"El grillo maneja la navaja",
													""=>""
												];
	
	//filas->player1, columnas->player2
	private var winnerMatrix:Array<Array<flash.utils.Object>> = [
											[{win:0, txt:""}, {win:1, txt:"pi-ti"}, {win:2, txt:"pi-pa"}, {win:1, txt:"pi-gr"}, {win:2, txt:"pi-nv"}],
											[{win:2, txt:"pi-ti"}, {win:0, txt:""}, {win:1, txt:"pa-ti"}, {win:1, txt:"ti-gr"}, {win:2, txt:"ti-nv"}],
											[{win:1, txt:"pi-pa"}, {win:2, txt:"pa-ti"}, {win:0, txt:""}, {win:2, txt:"pa-gr"}, {win:1, txt:"pa-nv"}],
											[{win:2, txt:"pi-gr"}, {win:2, txt:"ti-gr"}, {win:1, txt:"pa-gr"}, {win:0, txt:""}, {win:1, txt:"gr-nv"}],
											[{win:1, txt:"pi-nv"}, {win:1, txt:"ti-nv"}, {win:2, txt:"pa-nv"}, {win:2, txt:"gr-nv"}, {win:0, txt:""}]
										];

	private var P1:FlxSprite;
	private var P1Choose:Int=0;

	private var P2:FlxSprite;
	private var P2Choose:Int=0;

	private var fin:Bool=false;
	private var _blinkInterval : Float = 0.5; 
	private var _blinkTime : Float = 0; 
	private var pokeA:String="";
	private var pokeG:String="";

	private var chuletaP1:FlxSprite;
	private var chuletaP2:FlxSprite;

	override public function create():Void
	{
		super.create();

		FlxG.mouse.visible = false;

		var bg = new FlxSprite(0, 0, "assets/images/bg.jpg");
		add(bg);
		chuletaP1 = new FlxSprite(0, 60, "assets/images/chuleta_01mod.png");
		chuletaP1.visible = false;
		add(chuletaP1);
		chuletaP2 = new FlxSprite(FlxG.width-72, 60, "assets/images/chuleta_02mod.png");
		chuletaP2.visible = false;
		add(chuletaP2);

		P1TxtScore = new FlxText(12, 5, FlxG.width, "0");
		P1TxtScore.setFormat(null, 24, FlxColor.RED);
		P1TxtScore.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(P1TxtScore);	

		P2TxtScore = new FlxText(590, 5, FlxG.width, "0");
		P2TxtScore.setFormat(null, 24, FlxColor.LIME);
		P2TxtScore.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(P2TxtScore);

		resultadoRonda = new FlxText(0, 70, 0, "", 50);
		resultadoRonda.setFormat(null, 24, FlxColor.LIME);
		resultadoRonda.alignment = FlxTextAlign.CENTER;
		resultadoRonda.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		resultadoRonda.fieldWidth = FlxG.width;
		resultadoRonda.visible = false;
		add(resultadoRonda);
			
		var sprites = FlxAtlasFrames.fromTexturePackerJson("assets/images/grilloKidd.png", "assets/images/grilloKidd.json");
				
		var alturaBiciP1 = (Reg.P1=="Ralph")? 4:0;
		var alturaBiciP2 = (Reg.P2=="Ralph")? 4:0;
		P1 = new FlxSprite(-30, 274 + Reg.alturaMap[Reg.P1] - alturaBiciP1);
		P2 = new FlxSprite(620, 274 + Reg.alturaMap[Reg.P2] - alturaBiciP2);

		for(P in [P1, P2])
		{
			var regP = (P==P1)? Reg.P1 : Reg.P2;
			P.frames = sprites;
			P.animation.addByNames("quieto", [""+regP+"_quieto.png"]);
			var namesAnda = [];			
			for (i in 0...3)
			{
				namesAnda.push(regP+"-anda_" + i + ".png");
			}
			P.animation.addByNames("anda", namesAnda, 8);
			P.animation.addByNames("agitaMano", [regP+"_agitando_mano01.png",regP+"_agitando_mano02.png",regP+"_agitando_mano01.png",regP+"_agitando_mano02.png",regP+"_agitando_mano01.png"], 3, false);
			P.animation.addByNames("piensa", [regP+"_piensa01.png",regP+"_piensa02.png"], 3);
			P.animation.addByNames("quieto", [regP+"_piensa01.png"]);
			P.animation.addByNames("piedra", [regP+"_piedra.png"]);
			P.animation.addByNames("papel", [regP+"_papel.png"]);
			P.animation.addByNames("tijera", [regP+"_tijeras.png"]);
			P.animation.addByNames("grillo", [regP+"_grillo.png"]);
			P.animation.addByNames("navaja", [regP+"_navaja.png"]);
			P.animation.addByNames("muertoPiedra", [regP+"_momia.png"]);

			P.animation.play("anda");
			if(P==P2) P.scale.x = -1;
			add(P);
		}

		entraPlayer(P1);		

	}

	private function onCompleteIntro(player:FlxSprite):Void
	{
		//FlxG.log.add(P1.animation.curAnim.name);
		if(player.animation.curAnim.name == "quieto")
		{
			finIntro(player);
		}
	}

	private function entraPlayer(player:FlxSprite)
	{

		var introName:String = (player==P1)? "intro"+Reg.P1 : "intro"+Reg.P2;
		//FlxG.sound.play(introName);
		var introSound:FlxSound = new FlxSound();
		introSound.loadEmbedded(introName, false, false, onCompleteIntro.bind(player));
		introSound.play();
		FlxTween.tween((player==P1)? P1 : P2, {x: (player==P1)? 160: 380}, 4, {type:FlxTween.ONESHOT, onComplete:function(_)
																				{
																					player.animation.play("quieto");
																					if(Reg.P1=="Ralph" && player==P1) P1.y=274 + Reg.alturaMap[Reg.P1];
																					if(Reg.P2=="Ralph" && player==P2) P2.y=274 + Reg.alturaMap[Reg.P2];
																					if(!introSound.playing)
																					{
																						finIntro(player);
																					}																					
																				}});
	}

	private function finIntro(player:FlxSprite):Void
	{
		if (player==P1)
		{
			new FlxTimer().start(0.2, function(_){entraPlayer(P2);});
		}	
		else 
		{
			chuletaP1.visible = true;
			chuletaP2.visible = true;
			FlxG.sound.play("fight");
			juegaRonda();
		}
}

	private function juegaRonda()
	{
		pokeA="";
		pokeG="";
		resultadoRonda.visible = false;
		//resultadoRonda.text = "";
		P1Choose = Random.int(0,4);
		P2Choose = Random.int(0,4);
		P1.animation.play("piensa");
		P2.animation.play("piensa", true, false, 1);
		var temazo:FlxSound = new FlxSound();	
		temazo.loadEmbedded("rock-paper-scissors");
		temazo.onComplete = function():Void {
								P1.animation.play("agitaMano");
								P2.animation.play("agitaMano");
								var harriHorriHar:FlxSound = new FlxSound();
								harriHorriHar.loadEmbedded("harriHorriHar");
								harriHorriHar.play();
								new FlxTimer().start(1.6, function(_)
								{											
									//HACKERMAN WINS
									if(pokeG=="787887"){
										switch (P1Choose) {
											case 0:
												P2Choose=4;
											case 1:
												P2Choose=4;
											case 2:
												P2Choose=3;
											case 3:
												P2Choose=0;
											case 4:
												P2Choose=3;
											
										}
									}
									if(pokeA=="asassa"){
										switch (P2Choose) {
											case 0:
												P1Choose=4;
											case 1:
												P1Choose=4;
											case 2:
												P1Choose=3;
											case 3:
												P1Choose=0;
											case 4:
												P1Choose=3;											
										}
									}

									P1.animation.play(HandsMap[P1Choose]);
									P2.animation.play(HandsMap[P2Choose]);
									
									playerScore(winnerMatrix[P1Choose][P2Choose].win);
									resultadoRonda.text = resultadoTxtMap[winnerMatrix[P1Choose][P2Choose].txt];

									P1TxtScore.text = "" + P1Score;
									P2TxtScore.text = "" + P2Score;	
									resultadoRonda.visible = true;
									if(P1Score == 3)
									{
										playerMuere(P2);
									}
									else if(P2Score == 3)
									{
										playerMuere(P1);						
									}
									else{
										new FlxTimer().start(2,function(_){juegaRonda();});	
									}									
								}, 1);				
							};
		temazo.play();											
	}

	private function playerScore(p:Int):Void{
		if(p!=0)
			(p==1)? {P1Score+=1; resultadoRonda.color = FlxColor.RED;} : {P2Score+=1; resultadoRonda.color = FlxColor.LIME;};
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);	
		if (FlxG.keys.justPressed.ESCAPE) System.exit(0);

		if (FlxG.keys.justPressed.Z)
			P1Choose=0;
		if (FlxG.keys.justPressed.X)
			P1Choose=2;
		if (FlxG.keys.justPressed.C)
			P1Choose=1;
		if (FlxG.keys.justPressed.V)
			P1Choose=3;
		if (FlxG.keys.justPressed.B)
			P1Choose=4;

		if (FlxG.keys.justPressed.A)
			pokeA+="a";
		if (FlxG.keys.justPressed.S)
			pokeA+="s";
		
		if (FlxG.keys.justPressed.NUMPADONE || FlxG.keys.justPressed.ONE)
			P2Choose=0;
		if (FlxG.keys.justPressed.NUMPADTWO || FlxG.keys.justPressed.TWO)
			P2Choose=2;
		if (FlxG.keys.justPressed.NUMPADTHREE || FlxG.keys.justPressed.THREE)
			P2Choose=1;
		if (FlxG.keys.justPressed.NUMPADFOUR || FlxG.keys.justPressed.FOUR)
			P2Choose=3;
		if (FlxG.keys.justPressed.NUMPADFIVE || FlxG.keys.justPressed.FIVE)
			P2Choose=4;
		
		if (FlxG.keys.justPressed.NUMPADSEVEN || FlxG.keys.justPressed.SEVEN)
			pokeG+="7";
		if (FlxG.keys.justPressed.NUMPADEIGHT || FlxG.keys.justPressed.EIGHT)
			pokeG+="8";
		
		if(fin){
			_blinkTime -= FlxG.elapsed; 
	        if (_blinkTime <= 0) 
	        {
	                resultadoRonda.visible = !resultadoRonda.visible; 
	                _blinkTime += _blinkInterval; 
	        }

			if (FlxG.keys.justPressed.ESCAPE)
				System.exit(0);
			if (FlxG.keys.justPressed.SPACE)
				FlxG.switchState(new SelectState());			
		}
	}

	public function playerMuere(P:FlxSprite)
	{
		new FlxTimer().start(1, function(_)
		{
			P.animation.play("muertoPiedra");
			var fantasmaP:FlxSprite = new FlxSprite((P==P1)? P.x:P.x+20, P.y);
			fantasmaP.frames = FlxAtlasFrames.fromTexturePackerJson("assets/images/grilloKidd.png", "assets/images/grilloKidd.json");
			var regP = (P==P1)? Reg.P1 : Reg.P2;
			fantasmaP.animation.addByNames("vuela", [regP+"-fantasma_0.png",regP+"-fantasma_1.png", regP+"-fantasma_2.png"], 3);
			fantasmaP.animation.play("vuela");
			add(fantasmaP);
			FlxG.sound.play("vuelavuelavuela");
			FlxTween.tween(fantasmaP, {y: -100}, 4.5, {onComplete:function(_){
															fin=true;
															resultadoRonda.color = FlxColor.YELLOW;
															resultadoRonda.text = "Pulsa esc para terminar\nESPACIO para reiniciar";
														}});
		});		
	}
}
