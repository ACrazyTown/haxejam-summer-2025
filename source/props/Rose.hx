package props;

import states.PlayState;
import flixel.FlxG;

import data.LdtkProject.LdtkProject_Entity;

class Rose extends Plant
{
	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0)
    {
        super(entity, x, y);
        loadGraphic("assets/images/mainflower.png");
        throwable = false;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (broken)
        {
            PlayState.instance.die();
        }
    }
}
