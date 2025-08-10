package ui;

import flixel.FlxG;

enum abstract MouseState(String) from String to String
{
    var NORMAL = "normal";
    var CLICKABLE = "clickable";
}

class Mouse
{
    public static var state(default, null):MouseState;
    private static var stateAssets:Map<MouseState, String> = 
    [
        NORMAL => "assets/images/cursor-default.png",
        CLICKABLE => "assets/images/cursor-clickable.png"
    ];

    public static function setState(newState:MouseState):Void
    {
        if (newState != state)
        {
            FlxG.mouse.load(stateAssets.get(newState));
            state = newState;
        }
    }
}
