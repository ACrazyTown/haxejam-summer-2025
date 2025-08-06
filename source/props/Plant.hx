package props;

import flixel.math.FlxPoint;
import util.Constants;
import flixel.FlxObject;
import flixel.FlxG;

class Plant extends Entity
{
    var carrier:Player;

    var carried:Bool = false;
    var canPickup:Bool = false;
    var rooted:Bool = false;
    var falling:Bool = false;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        acceleration.y = Constants.GRAVITY;
        // maxVelocity.y = 600;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (carried)
        {
			x = carrier.x + ((carrier.width - width) / 2);
			y = carrier.y + ((carrier.height - height) / 2);

			if (FlxG.keys.justPressed.SPACE) 
            {
				carried = false;
                canPickup = false;
                falling = true;

                acceleration.y = Constants.GRAVITY;
                allowCollisions = ANY;
            }
        }
    }

    override function onOverlap(object:FlxObject) 
    {
        var player:Player = cast object;

        if (FlxG.keys.justPressed.SPACE && !carried && canPickup)
        {
            carrier = player;
            carried = !carried;

            trace("im caryieng");

            if (carried)
            {
                acceleration.y = 0;
                allowCollisions = NONE;
            }
        }
    }

    override function onCollision(object:FlxObject)
    {
        canPickup = true;
    }
    
    function root():Void
    {
        
    }
}
