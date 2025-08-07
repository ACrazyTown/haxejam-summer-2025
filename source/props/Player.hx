package props;

import flixel.math.FlxAngle;
import util.FlxVelocityEx;
import flixel.math.FlxPoint;
import states.PlayState;
import flixel.FlxObject;
import util.Constants;
import data.Controls;
import flixel.FlxG;

class Player extends Entity
{
    final PLAYER_WIDTH:Int = 90;
    final PLAYER_HEIGHT:Int = 200;
    
	public var canMove:Bool = true;

	// carrying
	public var carried:Plant = null;

	// throwing
	var throwPoint:FlxPoint = FlxPoint.get();
	var throwVelocity:FlxPoint = FlxPoint.get();

    public function new(x:Float = 0, y:Float = 0)
    {
		super(x, y);
		loadGraphic("assets/images/Player.png");

		drag.x = 1600;
		acceleration.y = Constants.GRAVITY;
		maxVelocity.set(200, Constants.GRAVITY);

		width /= 2;
		offset.x = width / 2;
    }

    override function update(elapsed:Float)
    {
		// why does movement need to be above super.update?
		if (canMove)
			updateMovement();

		updateCarrying();

		super.update(elapsed);
	}

	function updateMovement():Void
	{
		acceleration.x = 0;
		// velocity.x = 0;

		if (FlxG.keys.anyPressed(Controls.LEFT))
			// velocity.x = -200;
		    acceleration.x = -800;
		if (FlxG.keys.anyPressed(Controls.RIGHT))
			// velocity.x = 200;
		    acceleration.x = 800;
		if (FlxG.keys.anyPressed(Controls.UP) && isTouching(FLOOR))
			velocity.y = -350;
	}

	function updateCarrying():Void
	{
		if (carried != null)
		{
			carried.x = x + ((width - carried.width) / 2);
			carried.y = y + ((height - carried.height) / 2);

			if (carried.throwable)
			{
				if (FlxG.mouse.pressed)
				{
					PlayState.instance.trajectory.exists = true;

					throwPoint.set(FlxG.mouse.x, FlxG.mouse.y);

					var distance = throwPoint.distanceTo(carried.getMidpoint()) * 2;
					FlxVelocityEx.velocityFromAngle(throwVelocity, FlxAngle.degreesBetweenPoint(carried, throwPoint), distance);
					throwVelocity.negate();

					var center = carried.getMidpoint();
					PlayState.instance.trajectory.updateTrajectory(center, throwVelocity, carried.acceleration, carried.drag, carried.maxVelocity);
					center.put();
				}

				if (FlxG.mouse.justReleased)
				{
					carried.thrown = true;
					carried.velocity.copyFrom(throwVelocity);
					stopCarrying();

					PlayState.instance.trajectory.exists = false;
				}
			}

			// don't feel like adding another bool so just check if we're throwing
			// by checking if the trajectory is being drawn
			if (FlxG.keys.justPressed.SPACE && !PlayState.instance.trajectory.exists)
			{
				carried.canPickup = false;
				stopCarrying();
			}
		}
	}

	override function onCollision(object:FlxObject)
	{
		super.onCollision(object);

        if (carried != null)
        {
            if (velocity.y > 300)
            {
                // lie so it breaks
                carried.thrown = true;
                stopCarrying();
            }
        }
	}

	override function onOverlap(object:FlxObject)
	{
		if (Std.isOfType(object, Plant))
		{
			var plant:Plant = cast object;

			if (FlxG.keys.justPressed.SPACE && carried == null && plant.canPickup && !plant.rooted)
			{
				carried = plant;
				carried.carried = true;
                carried.carrier = this;
			}
		}
	}

	function stopCarrying():Void
	{
		carried.carried = false;
		carried = null;
	}
}
