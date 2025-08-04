package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.InitState;
import states.PlayState;

class Main extends Sprite
{
    public static var instance(default, null):Main;

    public var game:FlxGame;

    public function new()
    {
        super();
        Main.instance = this;

        game = new FlxGame(0, 0, InitState.new.bind(PlayState.new.bind("Level_0")), 60, 60, true, false);
        addChild(game);
    }
}
