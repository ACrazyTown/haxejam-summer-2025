package props;

import flixel.graphics.frames.FlxAtlasFrames;
import states.PlayState;
import ant.sound.SoundUtil;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import data.LdtkProject.LdtkProject_Entity;

class PlantPlatform extends Plant
{
    var oldSize:FlxPoint = FlxPoint.get();
    var wantedHeight:Null<Float>;
    
	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0, ?height:Float)
    {
        super(entity, x, y);
        this.wantedHeight = height;

		frames = FlxAtlasFrames.fromSparrow("assets/images/tree.png", "assets/images/tree.xml");
		animation.addByPrefix("idle", "tree", 6, false);
		animation.addByPrefix("root", "root", 6, false);
		animation.addByPrefix("land", "land", 6, false);
		animation.play("idle");
		updateHitbox();

		oldSize.set(width, this.height);

		animation.onFinish.add((name) ->
		{
			if (name == "root")
			{
				// oldSize.set(width, height);

				var offset = 30 * scale.y;
				this.height -= offset;
				this.offset.y += Math.floor(offset);

				this.y += offset;

				// x -= (width - oldSize.x) / 2;
				// y -= height - oldSize.y;

				velocity.y = 0;
				acceleration.y = 0;
				collidable = true;
				immovable = true;

				animation.play("land");
				animation.curAnim.stop();
			}
		});

		animation.onFrameChange.add((animName, frameNumber, frameIndex) -> 
        {
			if (animName == "root")
			{
				if (frameNumber == 3)
				{
					if (wantedHeight == null)
						wantedHeight = this.height;

					origin.set(width / 2, this.height);
					scale.y = wantedHeight / this.height;
					updateHitbox();

					this.y -= Math.ceil(height - oldSize.y);
				}
			}
		});

		throwable = true;
	}

	override function root():Void
	{
		super.root();

		animation.play("root");
		updateHitbox();

		x -= (width - oldSize.x) / 2;
		y -= height - oldSize.y;

		oldSize.set(width, height);

		var snd = SoundUtil.playSFXWithPitchRange("assets/sounds/tree", 0.7, 0.9, 1.1);
		snd.proximity(x, y, PlayState.instance.player, FlxG.width);
    }
}
