package props;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;

class PlantPlatform extends Plant
{
    var oldSize:FlxPoint = FlxPoint.get();
    var wantedHeight:Null<Float>;
    
    public function new(x:Float = 0, y:Float = 0, ?height:Float)
    {
        super(x, y);
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

        FlxTween.tween(this, {"scale.x": 1, "scale.y": wantedHeight / height}, 0.8, {ease: FlxEase.backOut, onComplete: (_) ->
        {
            // updateHitbox();
            // height = frameHeight * scale.y - 10 * scale.y;
            // width = frameWidth * scale.x - 10 * scale.x;

            acceleration.y = 0;
            collidable = true;
            immovable = true;
        }});
    }
}
