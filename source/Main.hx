package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

        #if (web || desktop)
            addChild(new FlxGame(200, 120, InitServerState, 1, 30, 30, true));
        #end

        #if mobile
            addChild(new FlxGame(160, 240, InitServerState, 1, 30, 30, true));
        #end
	}
}
