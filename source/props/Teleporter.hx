package props;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import data.LdtkProject.LdtkProject_Entity;

class Teleporter extends LdtkEntity
{
    var destination:FlxPoint;

	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0, destination:FlxPoint)
	{
        super(entity, x, y);
        this.destination = destination;

        makeGraphic(60, 200);

        collidable = false;
        immovable = true;
    }

    override function onOverlap(object:FlxObject) 
    {
        super.onOverlap(object);

        if (object is Player)
        {
            object.x = destination.x;
            object.y = destination.y;
        }
    }
}
