package props;

import states.PlayState;
import ant.math.MathEx;
import flixel.FlxG;
import util.Constants;
import flixel.sound.FlxSound;
import ant.sound.SoundUtil;
import flixel.FlxSprite;
import flixel.FlxObject;

class Mushroom extends Plant
{
    var sound:FlxSound;

    public function new(x:Float = 0, y:Float = 0)
    {
		super(x, y);

		loadGraphic("assets/images/mushroom.png");
		throwable = true;

        sound = FlxG.sound.load("assets/sounds/boing-m.ogg");
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

	override function onOverlap(object:FlxObject)
	{
        super.onOverlap(object);

		if (object is Entity)
		{
			var entity:Entity = cast object;
			if (rooted)
			{
                if (!sound.playing)
                {
                    sound.play();
                    sound.pitch = MathEx.eerp(0.8, 1.2);
                    sound.proximity(x, y, PlayState.instance.player, FlxG.width);
                }

				entity.velocity.y = Constants.MUSHROOM_JUMP_VELOCITY;

                if (object is Player)
                {
                    var dir = entity.animation.curAnim.name.charAt(entity.animation.curAnim.name.length - 1);
                    entity.animation.play('jump$dir');
                }
			}
        }
    }
}
