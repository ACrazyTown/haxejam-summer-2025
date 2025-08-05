package props;

import echo.shape.Rect;
import echo.Body;
import flixel.FlxG;
import flixel.FlxSprite;

using echo.FlxEcho;

class Player extends FlxSprite
{
    final PLAYER_WIDTH:Int = 90;
    final PLAYER_HEIGHT:Int = 200;
    
	public var body(default, null):Body;

    public var updateMovement:Bool = true;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y, "assets/images/Player.png");

		body = this.add_body({
			shape: {
				type: RECT,
				width: PLAYER_WIDTH / 2,
				height: PLAYER_HEIGHT,
				// offset_y: PLAYER_HEIGHT / 2 - 10, // crack mathemathics
			}
		});

		offset.x = 5;
		// offset.y = PLAYER_HEIGHT / 2 - 10;
    }

    override function update(elapsed:Float)
    {
		body.velocity.x = 0;

        if (updateMovement)
        {
            if (FlxG.keys.pressed.LEFT)
				body.velocity.x -= 240;
            if (FlxG.keys.pressed.RIGHT)
				body.velocity.x += 240;
            if (FlxG.keys.pressed.UP && isTouching(FLOOR))
				body.velocity.y -= 330;
        }

        // why does movement need to be above super.update?
        super.update(elapsed);
    }
	// public function setPositionReal(x:Float = 0, y:Float = 0)
	// {
	//     var rect:Rect = cast body.shape;
	//     body.y = height - rect.height;
	//     body.x = width / 2 - rect.width; // gfmlksvcncxyv
	// }
}
