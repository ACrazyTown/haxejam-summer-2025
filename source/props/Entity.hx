package props;

import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxSprite;

class Entity extends FlxSprite
{
    public var lastVelocity:FlxPoint;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

    public function onOverlap(object:FlxObject) {}

    public function onCollision(object:FlxObject) {}
}
