package props;

import states.PlayState;
import flixel.FlxObject;
import data.LdtkProject.LdtkProject_Entity;

class ExitArea extends LdtkEntity
{
    public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0)
    {
        super(entity, x, y);
        // makeGraphic(180, 300, FlxColor.RED);
        // alpha = 0.1;
        width = 180;
        height = 300;
        visible = false;
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
