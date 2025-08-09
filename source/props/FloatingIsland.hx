package props;

import flixel.math.FlxPoint;
import util.Constants;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;

class FloatingIsland extends Entity
{
    var fallTimer:Float = 0;

    var initialPos:FlxPoint = FlxPoint.get();
    var isColliding:Bool = false;

    var resetTime:Float = 1.5;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        initialPos.set(x, y);

        makeGraphic(300, 300, FlxColor.PURPLE);
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
                fallTimer = Math.max(fallTimer - (elapsed / 4), 0);
				velocity.y = -Constants.FLOATINGISLAND_VELOCITY * 8;
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
            fallTimer = Math.min(fallTimer + (FlxG.elapsed / 4), 1.5);
            velocity.y += Constants.FLOATINGISLAND_VELOCITY * fallTimer;
        }
    }
}
