package props;

import states.PlayState;
import flixel.FlxObject;
import flixel.util.FlxColor;

class ExitArea extends Entity
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        makeGraphic(180, 300, FlxColor.RED);
        alpha = 0.1;
    }

    override function onOverlap(object:FlxObject):Void
    {
        if (Std.isOfType(object, Player))
        {
            var player:Player = cast object;
            if (player.carried == null)
            {
                // TODO: DIALOGUE REMINDER INDICATOR THING
            }
            else if (Std.isOfType(player.carried, Rose))
            {
				PlayState.instance.runExitCutscene();
            }
        }
    }
}
