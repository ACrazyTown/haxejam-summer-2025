package props;

import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxAtlasFrames;
import states.PlayState;
import ant.math.MathEx;
import flixel.FlxG;
import util.Constants;
import flixel.sound.FlxSound;
import ant.sound.SoundUtil;
import flixel.FlxSprite;
import flixel.FlxObject;
import data.LdtkProject.LdtkProject_Entity;

class Mushroom extends Plant
{
	var oldSize:FlxPoint = FlxPoint.get();
    var sound:FlxSound;

	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0)
    {
		super(entity, x, y);
		frames = FlxAtlasFrames.fromSparrow("assets/images/mushroom.png", "assets/images/mushroom.xml");
		animation.addByPrefix("idle", "mushroom", 6, false);
		animation.addByPrefix("root", "root", 6, false);
		animation.addByPrefix("bounce", "bounce", 6, false);
		animation.play("idle");
		updateHitbox();

		oldSize.set(width, height);

		animation.onFinish.add((name) ->
		{
			if (name == "root")
			{
				animation.play("bounce");
				animation.curAnim.stop();
			}
		});

		throwable = true;

        sound = FlxG.sound.load("assets/sounds/boing.ogg");
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
			if (rooted && !entity.collidable && !entity.immovable)
			{
				if (entity is Plant)
				{
					var plant:Plant = cast entity;
					if (plant.rooted)
						return;
				}

                if (!sound.playing)
                {
                    sound.play();
                    sound.pitch = MathEx.eerp(0.8, 1.2);
                    sound.proximity(x, y, PlayState.instance.player, FlxG.width);
                }

                if (object is Player)
                {
                    var dir = entity.animation.curAnim.name.charAt(entity.animation.curAnim.name.length - 1);
                    entity.animation.play('jump$dir');
                }

				entity.velocity.y = Constants.MUSHROOM_JUMP_VELOCITY;
				animation.play("bounce");
			}
        }
    }
	override function root():Void
	{
		super.root();
		animation.play("root");
		updateHitbox();

		x -= (width - oldSize.x) / 2;
		y -= height - oldSize.y;
	}
}
