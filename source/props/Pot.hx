package props;

class Pot extends Plant
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic("assets/images/pot.png");
        throwable = true;
    }
}
