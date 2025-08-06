package ui;

import flixel.math.FlxVelocity;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.group.FlxContainer;

class Trajectory extends FlxTypedContainer<TrajectoryPoint>
{
    var numPoints:Int;

    public function new(numPoints:Int, pointRadius:Float)
    {
        super();
        this.numPoints = numPoints;

        for (i in 0...numPoints)
        {
            var point:TrajectoryPoint = new TrajectoryPoint(0, 0, pointRadius);
            // point.visible = false;
            add(point);
        }
    }

    public function updateTrajectory(startPos:FlxPoint, velocity:FlxPoint, acceleration:FlxPoint, drag:FlxPoint, max:FlxPoint)
    {
        final time = 0.1;
        for (i in 0...numPoints)
        {
            final t = time * i;

            // TODO: apply drag
			var dx = velocity.x * t + 0.5 * acceleration.x * t * t;
			var dy = velocity.y * t + 0.5 * acceleration.y * t * t;

            var x = dx + startPos.x;
            var y = dy + startPos.y;

            members[i].setPosition(x, y);
        }

        startPos.putWeak();
        velocity.putWeak();
        acceleration.putWeak();
        drag.putWeak();
        max.putWeak();
    }

	// https://github.com/HaxeFlixel/flixel/blob/master/flixel/math/FlxVelocity.hx#L232
    // function applyDrag(v:Float, d:Float)
    // {
	// 	if (v - d > 0)
	// 		v -= d;
	// 	else if (v + d < 0)
	// 		v += d;
	// 	else
	// 		v = 0;

    //     return v;
    // }
}
