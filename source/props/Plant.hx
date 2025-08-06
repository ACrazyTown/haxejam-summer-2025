package props;

import ant.sound.SoundUtil;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
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
	var throwPoint:FlxPoint = FlxPoint.get();
    var thrown:Bool = false;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
		drag.set(600, 600);
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

			if (FlxG.mouse.pressed)
			{
				throwPoint.set(FlxG.mouse.x, FlxG.mouse.y);
			}

			if (FlxG.mouse.justReleased)
			{
				stopCarrying();

				var distance = throwPoint.distanceTo(this.getMidpoint()) * 3;
				var throwVel = FlxVelocity.velocityFromAngle(FlxAngle.degreesBetweenPoint(this, throwPoint), distance);
				throwVel.negate();
				velocity.copyFrom(throwVel);

                thrown = true;
			}

			if (FlxG.keys.justPressed.SPACE) 
            {
				stopCarrying();
            }
        }
    }

    override function onOverlap(object:FlxObject) 
    {
        var player:Player = cast object;

        if (FlxG.keys.justPressed.SPACE && !carried && canPickup && !rooted)
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

        trace(velocity.length);
        if (thrown && !rooted && isTouching(FLOOR))
            root();
    }
    
    function root():Void
    {
        rooted = true;
        var sound = SoundUtil.playSFXWithPitchRange("assets/sounds/potbreak", 0.6, 0.9, 1.1);
        sound.proximity(this.x, this.y, carrier, FlxG.width);

        velocity.set(0, 0);
	}

	function stopCarrying():Void
	{
		carried = false;
		canPickup = false;
		falling = true;

		acceleration.y = Constants.GRAVITY;
		allowCollisions = ANY;
    }
}
