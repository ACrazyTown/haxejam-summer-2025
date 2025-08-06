package ui;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import openfl.display.Shape;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

class TrajectoryPoint extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, radius:Float)
    {
        super(x, y);

        var graphic:FlxGraphic = FlxG.bitmap.get('trajectorypoint$radius');
        if (graphic == null)
            graphic = generateGraphic(radius);

        loadGraphic(graphic);
    }

    function generateGraphic(radius:Float):FlxGraphic
    {
        var shape:Shape = new Shape();
		var size:Int = Math.round(radius * 2);
        var bitmap:BitmapData = new BitmapData(size, size, true, 0);

        shape.graphics.beginFill(0xFFFFFF, 1);
        shape.graphics.drawCircle(radius, radius, radius);
        shape.graphics.endFill();

        bitmap.draw(shape);
        
        shape = null;

		return FlxGraphic.fromBitmapData(bitmap, true, 'trajectorypoint$radius');
    }
}
