package states;

import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.FlxSprite;
import lime.system.System;
import flixel.util.typeLimit.NextState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

#if ACT_SPLASH
import ant.openfl.HTML5Video;
#end

class InitState extends FlxState
{
    var next:NextState;

    #if web
    #if ACT_SPLASH
    var video:HTML5Video;
    #end
    var text:FlxText;
    var needsInput:Bool = true;
    #end

    public function new(next:NextState)
    {
        super();
        this.next = next;
    }

    override function create():Void
    {
        #if ACT_COCONUTJPG
        acrazytown.CoconutHandler.checkIfCoconutValid();
        #end

        init();

        #if web
        needsInput = true;
        text = new FlxText(0, 0, 0, "Click to begin", 32);
        text.screenCenter();
        add(text);

        #if ACT_SPLASH
        video = new HTML5Video(() ->
        {
            FlxG.sound.onVolumeChange.remove(onVolumeChange);
            initComplete();
        });
        video.smoothing = true;
        FlxG.addChildBelowMouse(video);
        FlxG.sound.onVolumeChange.add(onVolumeChange);
        #end

        #else
        initComplete();
        #end
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        #if web
        if (needsInput && FlxG.mouse.justPressed)
        {
            needsInput = false;

            #if ACT_SPLASH
            video.play("assets/preload/splash.mp4");
            #else
            initComplete();
            #end
        }
        #end
    }

    function init():Void
    {
        var highestRefreshRate:Int = 0;
        for (i in 0...System.numDisplays)
        {
            var display = System.getDisplay(i);
            highestRefreshRate = Std.int(Math.max(highestRefreshRate, display.currentMode.refreshRate));
        }

        if (highestRefreshRate == 0)
            highestRefreshRate = 60;

		FlxG.updateFramerate = highestRefreshRate;
        FlxG.drawFramerate = highestRefreshRate;

        FlxSprite.defaultAntialiasing = false;
        FlxG.stage.quality = LOW;
        FlxG.scaleMode = new PixelPerfectScaleMode();

        #if web
        FlxG.stage.window.element.style.imageRendering = "pixelated";
        #end
    }

    function initComplete():Void
    {
        FlxG.switchState(next);
    }

    #if ACT_SPLASH
    function onVolumeChange(volume:Float):Void
    {
        video.volume = volume;
    }
    #end
}
