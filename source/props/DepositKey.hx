package props;

import flixel.FlxObject;
import ldtk.Json.EntityReferenceInfos;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import ldtk.Json.EntityInstanceJson;
import data.LdtkProject.LdtkProject_Entity;

class DepositKey extends LdtkEntity
{
	public var ldtkParent:EntityReferenceInfos;

    public var activated:Bool = false;
    var parent:PlantKey;

	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0, ldtkParent:EntityReferenceInfos)
    {
        super(entity, x, y);
		this.ldtkParent = ldtkParent;
        loadGraphic("assets/images/deposit.png");
        immovable = true;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    override function onOverlap(object:FlxObject) 
    {
        super.onOverlap(object);

        if (object == parent)
        {
			activated = true;
            var plant:Plant = cast object;
            plant.thrown = true;
        }
    }

	public function findParent(entities:FlxTypedGroup<Entity>)
	{
		for (entity in entities)
		{
			if (entity is PlantKey)
			{
				var lEntity:PlantKey = cast entity;
				if (lEntity.ldtkEntity.json.iid == ldtkParent.entityIid)
				{
					parent = cast lEntity;
					break;
				}
			}
		}

		if (parent == null)
			FlxG.log.warn("Bro is parentless (deposit)");
	}
}
