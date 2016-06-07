package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
        #if desktop
            addChild(new FlxGame(200, 120, MenuState, 1, 30, 30));
        #end

        #if mobile
            addChild(new FlxGame(160, 240, MenuState, 1, 30, 30));
        #end
	}
}
