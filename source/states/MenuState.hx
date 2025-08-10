package states;

import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import ui.FancyButton;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import ui.Mouse;
import flixel.FlxState;

class MenuState extends FlxState
{
	var mainMenuCam = new FlxCamera();
	var font = FlxBitmapFont.fromAngelCode("assets/font/badpixelz.png", "assets/font/badpixelz.xml");

	var fadeRect:FlxSprite;
	var logo:FlxSprite;

	var playButton:FancyButton;
	var creditsButton:FancyButton;
	var bottomText:FlxBitmapText;

	var timersDone = -1;

	public function new()
	{
		super();
	}

	override function create()
	{
		super.create();
		Mouse.setState(NORMAL);

		mainMenuCam.bgColor = 0xFF6D546D;
		FlxG.cameras.add(mainMenuCam, false);

		fadeRect = new FlxSprite(0, 0);
		fadeRect.camera = mainMenuCam;
		fadeRect.makeGraphic(1280, 720, FlxColor.BLACK);

		logo = new FlxSprite(0, 800, "assets/images/logo.png");
		logo.scale.scale(2, 2);
		logo.camera = mainMenuCam;
		logo.screenCenter(X);

		playButton = new FancyButton(0, 800, "assets/images/btn_play.png", () ->
		{
			trace("open playstate!");
		});
		playButton.camera = mainMenuCam;
		playButton.x = 1280 / 4 - playButton.width / 2;

		creditsButton = new FancyButton(0, 800, "assets/images/btn_credits.png", () ->
		{
			trace("open credits!");
		});
		creditsButton.camera = mainMenuCam;
		creditsButton.x = 3 * 1280 / 4 - creditsButton.width / 2;

		bottomText = new FlxBitmapText(0, 900, "(text here text here text here)", font);
		bottomText.camera = mainMenuCam;
		bottomText.screenCenter(X);

		add(logo);
		add(playButton);
		add(creditsButton);
		add(bottomText);
		add(fadeRect);

		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.color(fadeRect, 1.5, FlxColor.BLACK, FlxColor.TRANSPARENT);
		});
		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.tween(logo, {y: 120}, 2, {ease: FlxEase.cubeOut});
		});
		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.tween(playButton, {y: 400}, 2, {ease: FlxEase.cubeOut});
		});
		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.tween(creditsButton, {y: 400}, 2, {ease: FlxEase.cubeOut});
		});
		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.tween(bottomText, {y: 720 - 50}, 2, {ease: FlxEase.cubeOut});
		});
	}

	function timtime()
	{
		timersDone++;
		return timersDone * 0.2;
	}

	override function update(elapsed:Float) {}
}
