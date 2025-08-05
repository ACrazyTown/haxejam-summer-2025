package props;

import flixel.FlxSprite;

class Mushroom extends Entity
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic("assets/images/mushroom.png");
    }

	override public function onOverlap(player:Player):Void
    {
        player.velocity.y -= 600;
    }
}
