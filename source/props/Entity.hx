package props;

import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxSprite;

class Entity extends FlxSprite
{
    public var lastVelocity:FlxPoint;
    public var collidable:Bool = false;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

    public function onOverlap(object:FlxObject) 
    {
        if (collidable)
        {
            var didCollide = FlxObject.separate(this, object);
            if (didCollide)
            {
                if (object is Entity)
                    cast (object, Entity).onCollision(this);

                onCollision(object);
            }
        }
    }

    public function onCollision(object:FlxObject) {}
}
