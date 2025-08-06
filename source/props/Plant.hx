package props;

import ui.Trajectory;
import util.FlxVelocityEx;
import flixel.group.FlxSpriteContainer;
import flixel.FlxSprite;
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
	var rooting:Bool = false;
    var rooted:Bool = false;
	var broken:Bool = false;
	var throwPoint:FlxPoint = FlxPoint.get();
    var throwVelocity:FlxPoint = FlxPoint.get();
    var thrown:Bool = false;

    var trajectory:Trajectory;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
		drag.set(400, 400);
        acceleration.y = Constants.GRAVITY;
        // maxVelocity.y = 600;

        trajectory = new Trajectory(10, 2.5);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        trajectory.update(elapsed);

        if (carried)
        {
			x = carrier.x + ((carrier.width - width) / 2);
			y = carrier.y + ((carrier.height - height) / 2);

			if (FlxG.mouse.pressed)
			{
				throwPoint.set(FlxG.mouse.x, FlxG.mouse.y);

				var distance = throwPoint.distanceTo(this.getMidpoint()) * 3;
				FlxVelocityEx.velocityFromAngle(throwVelocity, FlxAngle.degreesBetweenPoint(this, throwPoint), distance);
				throwVelocity.negate();

                var center = getMidpoint();
                trajectory.updateTrajectory(center, throwVelocity, acceleration, drag, maxVelocity);
                center.put();
			}

			if (FlxG.mouse.justReleased)
			{
				stopCarrying();

				velocity.copyFrom(throwVelocity);
                thrown = true;
			}

			if (FlxG.keys.justPressed.SPACE) 
            {
				stopCarrying();
            }
        }
    }

    override function draw():Void
    {
        super.draw();
        trajectory.draw();
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
                moves = false;
                allowCollisions = NONE;
            }
        }
    }

    override function onCollision(object:FlxObject)
    {
        canPickup = true;

		if (thrown)
		{
			if (!broken)
			{
				var sound = SoundUtil.playSFXWithPitchRange("assets/sounds/potbreak", 0.6, 0.9, 1.1);
				sound.proximity(this.x, this.y, carrier, FlxG.width);
				broken = true;
			}

			if (isTouching(FLOOR))
				root();
		}
	}
    
    function root():Void
    {
		rooted = true;
        velocity.set(0, 0);
	}

	function stopCarrying():Void
	{
		carried = false;
		canPickup = false;

		moves = true;
		allowCollisions = ANY;
    }
}
