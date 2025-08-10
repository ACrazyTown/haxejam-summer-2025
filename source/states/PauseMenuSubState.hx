package states;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSubState;

class PauseMenuSubState extends FlxSubState
{
	var pauseCam:FlxCamera;
	var font = FlxBitmapFont.fromAngelCode("assets/font/badpixelz.png", "assets/font/badpixelz.xml");

	var squigglyTop:FlxSprite;
	var squigglyBottom:FlxSprite;

	var statusText:FlxBitmapText;
	var resumeText:FlxBitmapText;
	var backToMainText:FlxBitmapText;

	public function new()
	{
		super(0x93000000);

		pauseCam = new FlxCamera();
		pauseCam.bgColor = 0;
		FlxG.cameras.add(pauseCam, false);

		squigglyTop = new FlxSprite(1280, 50, "assets/images/squiggly.png");
		squigglyTop.camera = pauseCam;

		squigglyBottom = new FlxSprite(-1280, 720 - 50, "assets/images/squiggly.png");
		squigglyBottom.flipX = true;
		squigglyBottom.flipY = true;
		squigglyBottom.camera = pauseCam;

		FlxTween.tween(squigglyTop, {x: 0, y: squigglyTop.y}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(squigglyBottom, {x: 0, y: squigglyBottom.y}, 1, {ease: FlxEase.cubeOut});

		statusText = new FlxBitmapText(0, 170, "Paused", font);
		statusText.setBorderStyle(SHADOW, FlxColor.BLACK, 2);
		statusText.camera = pauseCam;
		statusText.scale.scale(3, 3);
		statusText.screenCenter(X);

		resumeText = new FlxBitmapText(0, 400, "Resume", font);
		resumeText.setBorderStyle(SHADOW, FlxColor.BLACK, 2);
		resumeText.camera = pauseCam;
		resumeText.scale.scale(2, 2);
		resumeText.x = 1280 / 4 - resumeText.width / 2;

		backToMainText = new FlxBitmapText(0, 400, "Main Menu", font);
		backToMainText.setBorderStyle(SHADOW, FlxColor.BLACK, 2);
		backToMainText.camera = pauseCam;
		backToMainText.scale.scale(2, 2);
		backToMainText.x = 3 * 1280 / 4 - backToMainText.width / 2;

		add(squigglyTop);
		add(squigglyBottom);
		add(statusText);
		add(resumeText);
		add(backToMainText);
	}

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
		}
	}
}
