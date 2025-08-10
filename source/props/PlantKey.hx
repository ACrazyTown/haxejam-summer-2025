package props;

import ldtk.Json.EntityInstanceJson;
import data.LdtkProject.LdtkProject_Entity;

class PlantKey extends Plant
{
	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0)
    {
        super(entity, x, y);
        loadGraphic("assets/images/plantkey.png");
        throwable = true;
    }
}
