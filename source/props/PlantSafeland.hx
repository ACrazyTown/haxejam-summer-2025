package props;

import flixel.FlxObject;
import data.LdtkProject.LdtkProject_Entity;

class PlantSafeland extends Plant
{
	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0)
    {
        super(entity, x, y);
        loadGraphic("assets/images/safeland.png");
        throwable = true;
    }

    override function onOverlap(object:FlxObject):Void
    {
        super.onOverlap(object);

        if (object is Player)
        {
            var player:Player = cast object;
            player.ignoreFallDamage = true;
        }
    }
}
