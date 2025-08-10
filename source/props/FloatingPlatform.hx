package props;

import util.Constants;
import flixel.path.FlxPath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import data.LdtkProject.LdtkProject_Entity;

class FloatingPlatform extends LdtkEntity
{
    var endPos:FlxPoint;

	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0, wide:Bool, endPos:FlxPoint)
    {
        super(entity, x, y);
        trace(x);

		this.endPos = endPos;
        makeGraphic(wide ? 240 : 120, 16, FlxColor.BLUE);

        path = new FlxPath([getPosition(), endPos]);
        path.centerMode = TOP_LEFT;
        path.start(null, Constants.FLOATINGPLATFORM_VELOCITY, LOOP_FORWARD);

        collidable = true;
        immovable = true;
    }
}
