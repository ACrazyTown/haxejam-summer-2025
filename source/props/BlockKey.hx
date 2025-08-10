package props;

import ldtk.Json.EntityReferenceInfos;
import flixel.group.FlxGroup.FlxTypedGroup;
import ldtk.Json.EntityInstanceJson;
import flixel.FlxG;
import data.LdtkProject.LdtkProject_Entity;

class BlockKey extends LdtkEntity
{
	public var ldtkParent:EntityReferenceInfos;
    var parent:DepositKey;
    var reverse:Bool;

    var cacheParentActivate:Bool;
    var isActive:Bool;

	public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0, ldtkParent:EntityReferenceInfos, ?reverse:Bool = false)
    {
        super(entity, x, y);
		this.ldtkParent = ldtkParent;
        this.reverse = reverse;

        loadGraphic('assets/images/blockkey-${reverse ? "inactive" : "active"}.png');

        collidable = true;
        immovable = true;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        updateState(false);

        // FlxG.watch.addQuick("a", parent.activated);
        // FlxG.watch.addQuick("ca", cacheParentActivate);
    }

    public function findParent(entities:FlxTypedGroup<Entity>)
    {
        for (entity in entities)
        {
			if (entity is DepositKey)
            {
				var lEntity:DepositKey = cast entity;
				if (lEntity.ldtkEntity.json.iid == ldtkParent.entityIid)
                {
                    parent = cast lEntity;
                    break;
                }
            }
        }

        if (parent == null)
            FlxG.log.warn("Bro is parentless (block)");

        updateState(true);
    }

    function updateState(?force:Bool = false)
    {
		if (parent.activated != cacheParentActivate || force)
		{
			cacheParentActivate = parent.activated;
			isActive = reverse ? parent.activated : !parent.activated;
			if (!isActive)
			{
				this.collidable = false;
				loadGraphic('assets/images/blockkey-inactive.png');
			}
			else
			{
				this.collidable = true;
				loadGraphic('assets/images/blockkey-active.png');
			}
		}
    }
}
