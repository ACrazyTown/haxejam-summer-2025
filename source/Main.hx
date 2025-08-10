package;

import haxe.macro.Compiler;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.InitState;
import states.PlayState;
import states.MenuState;

class Main extends Sprite
{
    public static var instance(default, null):Main;

    public var game:FlxGame;

    public function new()
    {
        super();
        Main.instance = this;

		var startingLevel:String = #if LEVEL Compiler.getDefine("LEVEL") #else "Level_0" #end;
		game = new FlxGame(0, 0, InitState.new.bind(#if LEVEL PlayState.new.bind(startingLevel) #else MenuState.new #end), 60, 60, true, false);
        addChild(game);
    }
}
