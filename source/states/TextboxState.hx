package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.text.FlxBitmapFont;
import flixel.addons.text.FlxTextTyper;
import flixel.text.FlxBitmapText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class TextboxState extends FlxSubState
{
	var textArray:Array<String>;
	var uiCamera:FlxCamera;

	var font = FlxBitmapFont.fromAngelCode("assets/font/badpixelz.png", "assets/font/badpixelz.xml");

	var bg:FlxSprite;
	var text:FlxBitmapText;
	var typer:FlxTextTyper;

	public function new(textArray_:Array<String>, uiCamera_:FlxCamera)
	{
		super();
		textArray = textArray_;
		uiCamera = uiCamera_;
		FlxG.state.persistentUpdate = true;
	}

	override function create()
	{
		super.create();

		bg = new FlxSprite(0, 20);
		bg.camera = uiCamera;
		bg.makeGraphic(900, 300, FlxColor.PURPLE);
		bg.screenCenter();
		add(bg);

		text = new FlxBitmapText(bg.x + 10, bg.y + 10, "", font);
		text.camera = uiCamera;
		add(text);

		typer = new FlxTextTyper();
		typer.onChange.add(() ->
		{
			text.text = typer.text;
		});
		add(typer);

		typer.startTyping(textArray[0]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
		}
	}

	override function destroy():Void
	{
		super.destroy();
		FlxG.state.persistentUpdate = false;
	}
}
