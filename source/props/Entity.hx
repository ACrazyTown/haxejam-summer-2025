package props;

import flixel.FlxObject;
import flixel.FlxSprite;

class Entity extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

    public function onOverlap(object:FlxObject) {}

    public function onCollision(object:FlxObject) {}
}
