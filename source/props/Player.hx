package props;

import flixel.math.FlxMath;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxAngle;
import util.FlxVelocityEx;
import flixel.math.FlxPoint;
import states.PlayState;
import flixel.FlxObject;
import util.Constants;
import data.Controls;
import flixel.FlxG;

using StringTools;

class Player extends Entity
{
    final PLAYER_WIDTH:Int = 90;
    final PLAYER_HEIGHT:Int = 200;
    
	public var canMove(default, set):Bool = true;

	// carrying
	public var carried:Plant = null;

	// throwing
	var throwPoint:FlxPoint = FlxPoint.get();
	var throwVelocity:FlxPoint = FlxPoint.get();

    public function new(x:Float = 0, y:Float = 0)
    {
		super(x, y);
		frames = FlxAtlasFrames.fromSparrow("assets/images/playeranim.png", "assets/images/playeranim.xml");

		animation.addByPrefix("idleL", "idle0", 6, true);
		animation.addByPrefix("idleBlinkL", "idleblink0", 6, true);
		animation.addByPrefix("idleR", "idle0", 6, true, true);
		animation.addByPrefix("idleBlinkR", "idleblink0", 6, true, true);
		animation.addByPrefix("walkL", "walk", 6, false);
		animation.addByPrefix("walkR", "walk", 6, false, true);

        animation.play("idleR");

        animation.onLoop.add((name) ->
		{
			var dir = name.charAt(name.length - 1);

			if (name.startsWith("idleBlink"))
			{
				animation.play('idle$dir', true);
			}
			else if (name.startsWith("idle"))
			{
				var shouldBlink = FlxG.random.bool(45);
				if (shouldBlink)
				{
					animation.play('idleBlink$dir', true);
				}
			}
		});

		// drag.x = 400;
		acceleration.y = Constants.GRAVITY;
		maxVelocity.set(Constants.PLAYER_WALK_VELOCITY, Constants.GRAVITY);

		width /= 2;
		offset.x = width / 2;
    }

    override function update(elapsed:Float)
    {
		// why does movement need to be above super.update?
		updateMovement();
		updateCarrying();

		super.update(elapsed);
	}

	var flipIdle:Bool = false;
	function updateMovement():Void
	{
		if (canMove)
		{
			velocity.x = 0;

			var leftP = FlxG.keys.anyPressed(Controls.LEFT);
			var rightP = FlxG.keys.anyPressed(Controls.RIGHT);
			var upP = FlxG.keys.anyPressed(Controls.UP);

			if (leftP)
			{
				velocity.x = -Constants.PLAYER_WALK_VELOCITY;
				animation.play("walkL");
				flipIdle = false;
			}

			if (rightP)
			{
				velocity.x = Constants.PLAYER_WALK_VELOCITY;
				animation.play("walkR");
				flipIdle = true;
			}

			if (upP && isTouching(FLOOR))
			{
				velocity.y = Constants.PLAYER_JUMP_VELOCITY;
			}

			if (!leftP && !rightP && !upP && !animation?.curAnim?.name.startsWith("idle"))
			{
				animation.play('idle${flipIdle ? "R" : "L"}');
			}
		}
	}

	function updateCarrying():Void
	{
		if (carried != null)
		{
			carried.x = x + ((width - carried.width) / 2);
			carried.y = y + ((height - carried.height) / 2) + 20;

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
			if (lastVelocity.y > Constants.FALL_DAMAGE_VELOCITY)
			{
				if (!ignoreFallDamage)
				{
					// lie so it breaks
					carried.thrown = true;
					carried.acceleration.y *= 2;
					stopCarrying();
				}
				ignoreFallDamage = false;
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
	function set_canMove(value:Bool):Bool
	{
		if (!value)
		{
			velocity.set(0, 0);
			animation.play('idle${flipIdle ? "R" : "L"}');
		}

		return canMove = value;
	}
}
