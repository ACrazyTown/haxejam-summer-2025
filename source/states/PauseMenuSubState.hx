package states;

import ui.FancyButton;
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

	var resumeButton:FancyButton;
	var mainMenuButton:FancyButton;

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

		resumeButton = new FancyButton(0, 400, "assets/images/btn_resume.png", close);
		resumeButton.camera = pauseCam;
		resumeButton.x = 1280 / 4 - resumeButton.width / 2;

		mainMenuButton = new FancyButton(0, 400, "assets/images/btn_main_menu.png", () ->
		{
			FlxG.switchState(MenuState.new);
		});
		mainMenuButton.camera = pauseCam;
		mainMenuButton.x = 3 * 1280 / 4 - mainMenuButton.width / 2;

		add(squigglyTop);
		add(squigglyBottom);
		add(statusText);
		add(resumeButton);
		add(mainMenuButton);
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
