package util;

import flixel.math.FlxPoint;
import flixel.math.FlxAngle;

class FlxVelocityEx
{
	/**
	 * FlxVelocity.velocityFromAngle but with the ability to pass in your own point
	 */
	public static function velocityFromAngle(?point:FlxPoint, angle:Float, speed:Float):FlxPoint
	{
        var p = point ?? FlxPoint.get();
		var a:Float = FlxAngle.asRadians(angle);
        p.x = Math.cos(a) * speed;
        p.y = Math.sin(a) * speed;
		return p;
	}
}
