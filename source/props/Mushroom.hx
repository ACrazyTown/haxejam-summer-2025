package props;

import flixel.sound.FlxSound;
import ant.sound.SoundUtil;
import flixel.FlxSprite;
import flixel.FlxObject;

class Mushroom extends Plant
{
    public function new(x:Float = 0, y:Float = 0)
    {
		super(x, y);

		loadGraphic("assets/images/mushroom.png");

        // offset.x = width / 1.5;
        // offset.y = height / 1.5;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

	override function onOverlap(object:FlxObject)
	{
        super.onOverlap(object);

		var player:Player = cast object;

        if (rooted)
        {
			player.velocity.y -= 600;
        }
    }
}
