package props;

import flixel.FlxG;

class MainFlower extends Entity
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y, "assets/images/mainflower.png");
    }

    override function onOverlap(player:Player):Void
    {
        if (FlxG.keys.justPressed.SPACE)
        {
            
        }
    }
}
