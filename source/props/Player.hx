package props;

// import echo.shape.Rect;
// import echo.Body;
import flixel.FlxG;
import flixel.FlxSprite;

// using echo.FlxEcho;

class Player extends FlxSprite
{
    final PLAYER_WIDTH:Int = 90;
    final PLAYER_HEIGHT:Int = 200;
    
	// public var body(default, null):Body;

    public var updateMovement:Bool = true;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y, "assets/images/Player.png");

		// body = this.add_body({
		// 	shape: {
		// 		type: RECT,
		// 		width: PLAYER_WIDTH / 2,
		// 		height: PLAYER_HEIGHT,
		// 		// offset_y: PLAYER_HEIGHT / 2 - 10, // crack mathemathics
		// 	}
		// });

		// offset.x = 5;
		// offset.y = PLAYER_HEIGHT / 2 - 10;
		drag.x = 1000;
		acceleration.y = 900;
		maxVelocity.set(240, 600);

		width /= 2;
		offset.x = width / 2;
    }

    override function update(elapsed:Float)
    {
		acceleration.x = 0;

        if (updateMovement)
        {
            if (FlxG.keys.pressed.LEFT)
				acceleration.x = -drag.x * 2;
            if (FlxG.keys.pressed.RIGHT)
				acceleration.x = drag.x * 2;
            if (FlxG.keys.pressed.UP && isTouching(FLOOR))
				velocity.y = -350;
        }

        // why does movement need to be above super.update?
        super.update(elapsed);
	}
}
