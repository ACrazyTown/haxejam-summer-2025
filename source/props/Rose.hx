package props;

import flixel.FlxG;

class Rose extends Plant
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic("assets/images/mainflower.png");
        throwable = false;
    }
}
