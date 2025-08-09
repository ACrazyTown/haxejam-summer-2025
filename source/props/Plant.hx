package props;

import ant.sound.SoundUtil;
import flixel.math.FlxPoint;
import util.Constants;
import flixel.FlxObject;
import flixel.FlxG;

class Plant extends Entity
{
	public var carriable:Bool;
	public var throwable:Bool;
	public var thrown:Bool = false;
	public var carried(default, set):Bool = false;
	public var carrier:Player;
	public var canPickup:Bool = false;
	public var rooted:Bool = false;

	var broken:Bool = false;

    public function new(x:Float = 0, y:Float = 0)
    {
		super(x, y);
		acceleration.y = Constants.GRAVITY;
    }

    override function onCollision(object:FlxObject)
    {
        if (!carried)
        {
            if (lastVelocity.y > Constants.FALL_DAMAGE_VELOCITY)
                thrown = true;
            else
                canPickup = true;
        }

		if (thrown)
		{
			if (!broken)
			{
				var sound = SoundUtil.playSFXWithPitchRange("assets/sounds/potbreak", 0.6, 0.9, 1.1);
				sound.proximity(x, y, carrier, FlxG.width);
				carrier = null;
				broken = true;
			}

			if (isTouching(FLOOR) && !rooted)
				root();
		}
	}
    
    function root():Void
    {
		rooted = true;
        velocity.set(0, 0);
	}

	@:noCompletion function set_carried(value:Bool):Bool
	{
		if (value)
		{
			allowCollisions = NONE;
			moves = false;
		}
		else
		{
			allowCollisions = ANY;
			moves = true;
		}

		return carried = value;
    }
}
