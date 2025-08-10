package props;

import flixel.math.FlxPoint;
import util.Constants;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import data.LdtkProject.LdtkProject_Entity;

class FloatingIsland extends LdtkEntity
{
    var fallTimer:Float = 0;

    var initialPos:FlxPoint = FlxPoint.get();
    var isColliding:Bool = false;

    var resetTime:Float = 1.5;

	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0)
    {
        super(entity, x, y);
        initialPos.set(x, y);

		loadGraphic("assets/images/platform_fall.png");
        height = 30;
        collidable = true;
        immovable = true;

        maxVelocity.y = 600;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    
        // velocity.y = -Constants.FLOATINGISLAND_VELOCITY;
        if (!isColliding)
        {
            resetTime -= elapsed;
            if (resetTime < 0)
            {
				fallTimer = Math.max(fallTimer - (elapsed / 2), 0);
				velocity.y = -Constants.FLOATINGISLAND_VELOCITY * 16;
                if (y <= initialPos.y)
                {
                    velocity.y = 0;
                    y = initialPos.y;
                }
            }
        }

        isColliding = false;
    }

    override function onCollision(object:FlxObject):Void
    {
        if (isTouching(UP))
        {
            isColliding = true;
            resetTime = 1.5;
			fallTimer = Math.min(fallTimer + (FlxG.elapsed / 2), 1.5);
            velocity.y += Constants.FLOATINGISLAND_VELOCITY * fallTimer;
        }
    }
}
