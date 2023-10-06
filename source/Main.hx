package;

import flixel.FlxGame;
import openfl.display.Sprite;

/*import com.yagp.GifDecoder;
import com.yagp.Gif;
import com.yagp.GifPlayer;
import com.yagp.GifPlayerWrapper;
import openfl.Assets;*/

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(620, 384, IntroState, -1, 60, 60, true, true));		
	}
}