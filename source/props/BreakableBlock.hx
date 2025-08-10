package props;

import flixel.FlxObject;
import data.LdtkProject.LdtkProject_Entity;

class BreakableBlock extends LdtkEntity
{
	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0)
    {
        super(entity, x, y);
        loadGraphic("assets/images/breakable.png");
        collidable = true;
        immovable = true;
    }

    override function onCollision(object:FlxObject) 
    {
        if (object is Plant)
        {
            var plant:Plant = cast object;
            if (plant.thrown)
            {
                // break
                allowCollisions = NONE;
                collidable = false;
                visible = false;
            }
        }
    }
}
