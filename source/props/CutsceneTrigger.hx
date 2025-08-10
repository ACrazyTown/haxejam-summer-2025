package props;

import states.PlayState;
import states.EndingCutscene;
import flixel.FlxObject;
import data.LdtkProject.LdtkProject_Entity;

class CutsceneTrigger extends LdtkEntity
{
	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0) 
    {
        super(entity, x, y);

        width = 850;
        height = 450;
    }

    override function onOverlap(object:FlxObject) 
    {
        super.onOverlap(object);

        if (object is Player)
        {
			PlayState.instance.controlsText.visible = false;
			PlayState.instance.textboxIsOpen = true;
			PlayState.instance.openSubState(new EndingCutscene());
        }
    }
}
