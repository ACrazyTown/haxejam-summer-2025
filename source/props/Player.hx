package props;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    final PLAYER_WIDTH:Int = 90;
    final PLAYER_HEIGHT:Int = 200;
    
    public var updateMovement:Bool = true;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y, "assets/images/Player.png");

        maxVelocity.set(240, 300);
        drag.x = maxVelocity.x * 8;
        acceleration.y = maxVelocity.y * 4;

        width /= 2;
        offset.x = width / 2;
        height = 20;
        offset.y = PLAYER_HEIGHT - height;
    }

    override function update(elapsed:Float)
    {
		acceleration.x = 0;

        if (updateMovement)
        {
            if (FlxG.keys.pressed.LEFT)
                acceleration.x = -maxVelocity.x * 4;
            if (FlxG.keys.pressed.RIGHT)
                acceleration.x = maxVelocity.x * 4;
            if (FlxG.keys.pressed.UP && isTouching(FLOOR))
            {
                velocity.y = -maxVelocity.y * 4;
            }
        }

        // why does movement need to be above super.update?
		super.update(elapsed);
    }
}
