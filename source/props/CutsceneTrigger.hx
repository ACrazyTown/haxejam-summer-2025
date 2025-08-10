package props;

import states.PlayState;
import states.EndingCutscene;
import flixel.FlxObject;
import data.LdtkProject.LdtkProject_Entity;

class CutsceneTrigger extends LdtkEntity
{
    var called:Bool = false;

	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0) 
    {
        super(entity, x, y);
        makeGraphic(850, 450);
        visible = false;
    }

    override function onOverlap(object:FlxObject) 
    {
        super.onOverlap(object);

        if (object is Player && !called)
        {
			PlayState.instance.controlsText.visible = false;
			PlayState.instance.textboxIsOpen = true;
			PlayState.instance.openSubState(new EndingCutscene());
            called = true;
        }
    }
}
