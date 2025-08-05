package util;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import ldtk.Layer_Tiles;
import data.LdtkProject.LdtkProject_Level;

class LdtkUtil
{
	public static function createTileArray(layer:Layer_Tiles):Array<Int>
	{
		return [
			for (y in 0...layer.cHei)
			{
				for (x in 0...layer.cWid)
				{
					if (layer.hasAnyTileAt(x, y))
					{
						layer.getTileStackAt(x, y)[0].tileId;
					}
					else
						-1; // empty tile
				}
			}
		];
	}
}
