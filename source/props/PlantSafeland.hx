package props;

import flixel.FlxObject;

class PlantSafeland extends Plant
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic("assets/images/safeland.png");
        throwable = true;
    }

    override function onOverlap(object:FlxObject):Void
    {
        super.onOverlap(object);

        if (object is Player)
        {
            trace("get trolled idiot");
            var player:Player = cast object;
            player.ignoreFallDamage = true;
        }
    }
}
