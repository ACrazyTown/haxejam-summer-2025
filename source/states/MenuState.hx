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
	var levelSelectButton:FancyButton;
	var creditsButton:FancyButton;

	var timersDone = -1;

	final BUTTONS_Y = 460;

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
		logo.camera = mainMenuCam;
		logo.screenCenter(X);

		playButton = new FancyButton(0, 800, "assets/images/btn_play.png", () ->
		{
			trace("open playstate!");
		});
		playButton.camera = mainMenuCam;
		playButton.x = 1280 / 6 - playButton.width / 2;

		levelSelectButton = new FancyButton(0, 800, "assets/images/btn_level_select.png", () ->
		{
			trace("open level select!");
		});
		levelSelectButton.camera = mainMenuCam;
		levelSelectButton.x = 3 * 1280 / 6 - levelSelectButton.width / 2;

		creditsButton = new FancyButton(0, 800, "assets/images/btn_credits.png", () ->
		{
			trace("open credits!");
		});
		creditsButton.camera = mainMenuCam;
		creditsButton.x = 5 * 1280 / 6 - creditsButton.width / 2;

		add(logo);
		add(playButton);
		add(levelSelectButton);
		add(creditsButton);
		add(fadeRect);

		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.color(fadeRect, 1.5, FlxColor.BLACK, FlxColor.TRANSPARENT);
		});
		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.tween(logo, {y: 15}, 2, {ease: FlxEase.cubeOut});
		});
		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.tween(playButton, {y: BUTTONS_Y}, 2, {ease: FlxEase.cubeOut});
		});
		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.tween(levelSelectButton, {y: BUTTONS_Y}, 2, {ease: FlxEase.cubeOut});
		});
		FlxTimer.wait(timtime(), () ->
		{
			FlxTween.tween(creditsButton, {y: BUTTONS_Y}, 2, {ease: FlxEase.cubeOut});
		});
	}

	function timtime()
	{
		timersDone++;
		return timersDone * 0.2;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
