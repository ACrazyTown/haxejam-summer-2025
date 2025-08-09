package props;

import util.Constants;
import flixel.path.FlxPath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class FloatingPlatform extends Entity
{
    var endPos:FlxPoint;

    public function new(x:Float = 0, y:Float = 0, wide:Bool, endPos:FlxPoint)
    {
        super(x, y);
        trace(x);
        makeGraphic(wide ? 240 : 120, 16, FlxColor.BLUE);
        this.endPos = endPos;

        path = new FlxPath([getPosition(), endPos]);
        path.start(null, Constants.FLOATINGPLATFORM_VELOCITY, LOOP_FORWARD);

        collidable = true;
        immovable = true;
    }
}
