package util;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import echo.util.TileMap;
import ldtk.Layer_Tiles;
import data.LdtkProject.LdtkProject_Level;

class LdtkUtil
{
	public static function createTileArray(?tiles:Layer_Tiles):Array<Int>
	{
		var array:Array<Int> = [];

		for (i in 0...tiles.cWid)
		{
			for (j in 0...tiles.cHei)
			{
				if (tiles.hasAnyTileAt(i, j))
				{
					array.push(tiles.getTileStackAt(i, j)[0].tileId);
				}
				else
				{
					array.push(-1);
				}
			}
		}

		return array;
	}
}
