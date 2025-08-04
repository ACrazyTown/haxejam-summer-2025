package;

import openfl.Lib;
import vfx.OverlayBlend;
import openfl.filters.BitmapFilterQuality;
import openfl.filters.BlurFilter;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import flixel.system.FlxBasePreloader;

@:keep
@:bitmap("assets/preload/glow.png")
class GlowBitmapData extends BitmapData {}

@:keep
@:bitmap("assets/preload/bar.png")
class BarBitmapData extends BitmapData {}

@:keep
@:bitmap("assets/preload/scanline.png")
class ScanlineBitmapData extends BitmapData {}

class ACTPreloader extends FlxBasePreloader
{
    var glow:Bitmap;
    var bar:Bitmap;
    var scanline:Bitmap;

    var _centerX:Float;
    var _centerY:Float;

    override function create():Void
    {
        super.create();

        _width = stage.stageWidth;
        _height = stage.stageHeight;
        _centerX = _width / 2;
        _centerY = _height / 2;

        glow = createBitmap(GlowBitmapData, (glow) ->
        {
            glow.filters = [new BlurFilter(24, 24, BitmapFilterQuality.HIGH)];
            glow.y = (_height - glow.height) / 2;
            glow.scaleX = 0;
            glow.smoothing = true;
        });
        addChild(glow);

        bar = createBitmap(BarBitmapData, (bar) ->
        {
            bar.filters = [new BlurFilter(3, 3, BitmapFilterQuality.HIGH)];
            bar.y = (_height - bar.height) / 2;
            bar.scaleX = 0;
            bar.smoothing = true;
            bar.blendMode = ADD;
        });
        addChild(bar);

        loadBitmapData(ScanlineBitmapData, (scanline) ->
        {
            glow.shader = new OverlayBlend(scanline);
            bar.shader = new OverlayBlend(scanline);
        });
    }

    override function update(percent:Float) 
    {
        super.update(percent);

        var barPadding = (bar.bitmapData.width - (percent * bar.bitmapData.width)) / 2;
        bar.scaleX = percent;
        bar.x = 20 + barPadding;

        var glowPadding = (glow.bitmapData.width - (percent * glow.bitmapData.width)) / 2;
        glow.scaleX = percent;
        glow.x = 10 + glowPadding;

        if (percent >= 0.9)
        {
            var diff = 1 - ((percent - 0.9) / 0.1);

            bar.alpha = diff;
            glow.alpha = diff;

            var barPadY = (bar.bitmapData.height - (diff * bar.bitmapData.height)) / 2;
            bar.scaleY = diff;
            bar.y = _centerY - 10 + barPadY;

            var glowPadY = (glow.bitmapData.height - (diff * glow.bitmapData.height)) / 2;
            glow.scaleY = diff;
            glow.y = _centerY - 20 + glowPadY;
        }
        // else
        // {
        // 	glow.alpha = random(0.7, 1);
        // }
    }

    // inline function random(min:Float, max:Float):Float
    // {
    // 	return Math.random() * (max - min) + min;
    // }

    #if ACT_PRELOADERTEST
    override function onEnterFrame(E:openfl.events.Event):Void
    {
        update(Math.abs(Math.sin(openfl.Lib.getTimer() / 1000)));
    }
    #end
}
