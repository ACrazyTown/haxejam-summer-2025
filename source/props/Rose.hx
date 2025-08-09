package props;

import states.PlayState;
import flixel.FlxG;

class Rose extends Plant
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic("assets/images/mainflower.png");
        throwable = false;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (broken)
        {
            PlayState.instance.die();
        }
    }
}
