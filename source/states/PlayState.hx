package states;

import util.LdtkUtil;
import echo.util.TileMap;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import data.LdtkProject;
import flixel.tile.FlxTilemap;
import props.Player;
import flixel.FlxState;

using echo.FlxEcho;

class PlayState extends FlxState
{
    var levelID:String;
    var project:LdtkProject;
	var level:LdtkProject_Level;

    var camGame:FlxCamera;
    var camUI:FlxCamera;

    var uiGroup:FlxGroup;

	var tilemap:FlxGroup;
    var collisionMap:FlxTilemap;

    var player:Player;

	var cameraViewMoveSpeed:Int = 400;
    var cameraViewMode:Bool;
    var cameraViewObject:FlxObject;
    var cameraViewGroup:FlxGroup;

    public function new(level:String)
    {
        super();
        this.levelID = level;
    }

    override public function create()
    {
        super.create();
		project = new LdtkProject();
		level = project.all_worlds.Default.getLevel(levelID);
		final levelWidth:Int = level.pxWid;
		final levelHeight:Int = level.pxHei;

		FlxEcho.init({
			x: 0,
			y: 0,
			width: levelWidth,
			height: levelHeight,
			gravity_y: 800
		});
		FlxEcho.draw_debug = true;

        camGame = new FlxCamera();
        camGame.bgColor = 0;
        FlxG.cameras.reset(camGame);

        camUI = new FlxCamera();
        camUI.bgColor = 0;
        FlxG.cameras.add(camUI, false);

        uiGroup = new FlxGroup();
        add(uiGroup);

		initTilemap();

        var spawnPos = level.l_Entities.all_PlayerSpawnPos[0];
		player = new Player();
		player.body.x = spawnPos.pixelX;
		player.body.y = spawnPos.pixelY;
        add(player);

        FlxG.camera.follow(player, PLATFORMER, 1);
		FlxG.worldBounds.set(0, 0, levelWidth, levelHeight);
		FlxG.camera.setScrollBounds(0, levelWidth, 0, levelHeight);

        // camera view mode
        cameraViewGroup = new FlxGroup();
        cameraViewGroup.camera = camUI;
        cameraViewGroup.visible = false;
        add(cameraViewGroup);

        cameraViewObject = new FlxObject();
        add(cameraViewObject);

		// TODO: up and down arrows are misaligned because their hitbox doesn't change
        var arrowL:FlxSprite = new FlxSprite(0, 0, "assets/images/camviewarrow.png");
        arrowL.screenCenter(Y);
        arrowL.x = 10;
        cameraViewGroup.add(arrowL);

        var arrowR:FlxSprite = arrowL.clone();
        arrowR.screenCenter(Y);
        arrowR.x = FlxG.width - arrowR.width - 10;
        arrowR.flipX = true;
        cameraViewGroup.add(arrowR);

        var arrowD:FlxSprite = arrowR.clone();
        arrowD.angle = 270;
        arrowD.screenCenter(X);
        arrowD.y = FlxG.height - arrowD.height - 10;
        cameraViewGroup.add(arrowD);

        var arrowU:FlxSprite = arrowD.clone();
        arrowU.angle = 90;
        arrowU.screenCenter(X);
        arrowU.y = 10;
        cameraViewGroup.add(arrowU);
		player.listen(tilemap);
    }

    override public function update(elapsed:Float)
    {
        // FlxG.collide(player, collisionMap);
        super.update(elapsed);
		// FlxG.collide(player, collisionMap);

        if (FlxG.keys.justPressed.ENTER)
        {
            // camGame.updateMovement = !camGame.updateMovement;
            // player.updateMovement = !camGame.updateMovement;
            cameraViewMode = !cameraViewMode;
            player.updateMovement = !cameraViewMode;
            cameraViewGroup.visible = cameraViewMode;

            FlxG.camera.target = cameraViewMode ? null : player;
        }

        if (cameraViewMode)
        {
            if (FlxG.keys.pressed.LEFT)
                camera.scroll.x -= cameraViewMoveSpeed * elapsed;
            if (FlxG.keys.pressed.RIGHT)
                camera.scroll.x += cameraViewMoveSpeed * elapsed;
            if (FlxG.keys.pressed.UP)
                camera.scroll.y -= cameraViewMoveSpeed * elapsed;
            if (FlxG.keys.pressed.DOWN)
                camera.scroll.y += cameraViewMoveSpeed * elapsed;
        }
    }
	function initTilemap():Void
	{
		tilemap = new FlxGroup();
		add(tilemap);

		final tiles = level.l_Tiles;
		for (cx in 0...tiles.cWid)
		{
			for (cy in 0...tiles.cHei)
			{
				if (tiles.hasAnyTileAt(cx, cy))
				{
					var tile = tiles.getTileStackAt(cx, cy)[0];
					var tileSprite = new FlxSprite(cx * tiles.gridSize + tiles.pxTotalOffsetX, cy * tiles.gridSize + tiles.pxTotalOffsetY);
					tileSprite.frame = tiles.tileset.getFrame(tile.tileId);
					tileSprite.updateHitbox();
					tileSprite.add_body({mass: STATIC});
					tileSprite.add_to_group(tilemap);

					trace(tileSprite.x, tileSprite.y);
				}
			}
		}
	}
}
