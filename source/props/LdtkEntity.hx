package props;

import data.LdtkProject.LdtkProject_Entity;

class LdtkEntity extends Entity
{
    public var ldtkEntity:LdtkProject_Entity;

    public function new(entity:LdtkProject_Entity, x:Float = 0, y:Float = 0)
    {
        super(x, y);
        ldtkEntity = entity;
    }
}
