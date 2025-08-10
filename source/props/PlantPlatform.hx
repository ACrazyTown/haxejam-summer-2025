package props;

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

        loadGraphic("assets/images/platformplant.png");
		oldSize.set(width, this.height);
        throwable = true;
    }

    override function root():Void
    {
        super.root();

        loadGraphic("assets/images/platformplant_rooted.png");
        updateHitbox();
        if (wantedHeight == null)
            wantedHeight = height;

        origin.set(width / 2, height);

        x -= (width - oldSize.x) / 2;
        y -= height - oldSize.y;

		// scale.x = oldSize.x / width;
        scale.x = 2;
		scale.y = oldSize.y / height;

		var snd = SoundUtil.playSFXWithPitchRange("assets/sounds/tree", 0.7, 0.9, 1.1);
		snd.proximity(x, y, PlayState.instance.player, FlxG.width);

		FlxTween.tween(this, {"scale.x": 1, "scale.y": wantedHeight / height}, 1, {
			ease: FlxEase.backOut,
			onComplete: (_) ->
        {
				oldSize.set(width, height);
				updateHitbox();

				var offset = 40 * scale.y;
				height -= offset;
				this.offset.y += Math.floor(offset);

				x -= (width - oldSize.x) / 2;
				y -= height - oldSize.y;

            // height = frameHeight * scale.y - 10 * scale.y;
            // width = frameWidth * scale.x - 10 * scale.x;

            acceleration.y = 0;
            collidable = true;
            immovable = true;
        }});
    }
}
