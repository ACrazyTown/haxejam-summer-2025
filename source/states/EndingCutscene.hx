package states;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSubState;

class EndingCutscene extends FlxSubState
{
    var overlay:FlxSprite;
    var cutscene:FlxSprite;

    override function create():Void
    {
        super.create();

        overlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.scrollFactor.set();
        overlay.screenCenter();
        overlay.alpha = 0;

        FlxG.sound.music.fadeOut(1, 0);
        FlxTween.tween(overlay, {alpha: 1}, 2, {onComplete: (_) ->
        {
            cutscene = new FlxSprite().loadGraphic("assets/images/ending/frame0001.png");
            cutscene.scrollFactor.set();
            cutscene.screenCenter();
            cutscene.alpha = 1;
            add(cutscene);

			add(overlay);
            
            FlxG.sound.playMusic("assets/music/sad", 0);
            FlxG.sound.music.fadeIn(3, 0, 0.7);
            FlxTween.tween(overlay, {alpha: 0}, 1);

            var txt = new TextboxState([
				"Hello Lily....",
				"Sorry it's been so long since the last time I've visited...",
				"It's just... It's been difficult.",
				"I couldn't really focus on anything after you left.",
				"The garden kinda got a bit ruined...",
				"But I did manage to fix it! So no need for you to worry!",
				"I grew this one from the seeds we bought together...",
				"...",
				"I miss you a lot...",
				"I hope you'll be patient...",
				"I promise to come visit more often..."
            ], PlayState.instance.camUI, false);
            txt.closeCallback = () -> {
				cutscene.loadGraphic("assets/images/ending/frame0003.png");
                FlxTimer.wait(2, () ->
                {
                    FlxG.sound.music.fadeOut(5, 0);
                    FlxTween.tween(overlay, {alpha: 1}, 5, {
                        onComplete: (_) ->
                        {
                            FlxG.switchState(MenuState.new);
                        }
                    });
                });
            }
            openSubState(txt);
        }});
    }
}
