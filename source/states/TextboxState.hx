package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.text.FlxBitmapFont;
import flixel.addons.text.FlxTextTyper;
import flixel.text.FlxBitmapText;
import flixel.FlxSprite;

class TextboxState extends FlxSubState
{
	// not using normal prefix because it looks better this way
	// by the way... the > character doesn't work...?
	final PREFIX = "* ";

	var textArray:Array<String>;
	var uiCamera:FlxCamera;
	var isAtBottom:Bool;

	var font = FlxBitmapFont.fromAngelCode("assets/font/badpixelz.png", "assets/font/badpixelz.xml");

	var bg:FlxSprite;
	var text:FlxBitmapText;
	var typer:FlxTextTyper;

	var arrow:FlxSprite;

	var current = 0;

	public function new(textArray_:Array<String>, uiCamera_:FlxCamera, isAtBottom_:Bool)
	{
		super();
		textArray = textArray_;
		uiCamera = uiCamera_;
		isAtBottom = isAtBottom_;
		FlxG.state.persistentUpdate = true;
	}

	override function create()
	{
		super.create();

		bg = new FlxSprite(0, isAtBottom ? 495 : 40);
		bg.camera = uiCamera;
		bg.makeGraphic(850, 200, 0xDD2B1A30);
		bg.screenCenter(X);
		add(bg);

		text = new FlxBitmapText(bg.x + 16, bg.y + 16, "", font);
		text.camera = uiCamera;
		add(text);

		arrow = new FlxSprite(0, 0, "assets/images/textbox_arrow.png");
		arrow.camera = uiCamera;
		arrow.x = bg.x + bg.width - 32;
		arrow.y = bg.y + bg.height - arrow.height / 2;

		typer = new FlxTextTyper();
		typer.onChange.add(() ->
		{
			text.text = typer.text;
		});
		typer.onTypingComplete.add(() ->
		{
			add(arrow);
		});
		add(typer);

		// check comment at the top of class
		typer.startTyping(PREFIX + textArray[current]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			current++;
			remove(arrow);
			if (current > textArray.length - 1)
				close();
			else
				// again, check comment at the top of class
				typer.startTyping(PREFIX + textArray[current]);
		}
	}

	override function destroy():Void
	{
		super.destroy();
		FlxG.state.persistentUpdate = false;
	}
}
