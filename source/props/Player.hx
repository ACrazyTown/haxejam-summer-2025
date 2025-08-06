package props;

// import echo.shape.Rect;
// import echo.Body;
import util.Constants;
import data.Controls;
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
		// drag.x = 1600;
		acceleration.y = Constants.GRAVITY;
		maxVelocity.set(200, Constants.GRAVITY);

		width /= 2;
		offset.x = width / 2;
    }

    override function update(elapsed:Float)
    {
		// acceleration.x = 0;
        velocity.x = 0;

        if (updateMovement)
        {
			if (FlxG.keys.anyPressed(Controls.LEFT))
				velocity.x = -200;
			    // acceleration.x = -800;
			if (FlxG.keys.anyPressed(Controls.RIGHT))
				velocity.x = 200;
			    // acceleration.x = 800;
			if (FlxG.keys.anyPressed(Controls.UP) && isTouching(FLOOR))
				velocity.y = -350;
        }

        // why does movement need to be above super.update?
        super.update(elapsed);
	}
}
