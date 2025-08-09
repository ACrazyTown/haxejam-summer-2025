package util;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import ldtk.Layer_Tiles;
import data.LdtkProject.LdtkProject_Level;

class LdtkUtil
{
	public static function createTileArray(layer:Layer_Tiles):Array<Int>
	{
        var level = [];
        trace("Building level");

        for (y in 0...layer.cHei)
        {
            for (x in 0...layer.cWid)
            {
                if (layer.hasAnyTileAt(x, y))
                {
					var stack = layer.getTileStackAt(x, y);
                    if (stack.length > 1)
                        trace('Found duplicate tile at $x, $y (stack length: ${stack.length})');

                    level.push(stack[0].tileId);
                }
                else
                    level.push(-1); // empty tile
            }
        }

        return level;
	}
}
