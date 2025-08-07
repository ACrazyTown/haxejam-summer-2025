package states;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import props.ExitArea;
import ui.trajectory.Trajectory;
import props.MainFlower;
import props.Mushroom;
import props.Entity;
import flixel.addons.tile.FlxTilemapExt;
import util.LdtkUtil;
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

// using echo.FlxEcho;

class PlayState extends FlxState
{
    public static var instance:PlayState;

    var levelID:String;
    var project:LdtkProject;
	var level:LdtkProject_Level;

    var camGame:FlxCamera;
    var camUI:FlxCamera;

    var uiGroup:FlxGroup;

	public var tilemap:FlxTilemapExt;
	var entities:FlxTypedGroup<Entity>;

    var player:Player;

	public var trajectory:Trajectory;

	var cameraViewMoveSpeed:Int = 400;
    public var cameraViewMode:Bool;
    var cameraViewObject:FlxObject;
    var cameraViewGroup:FlxGroup;

	final CAMERA_PADDING:Int = 200;

    public function new(level:String)
    {
        super();
        instance = this;

        this.levelID = level;
    }

    override public function create()
    {
        super.create();
		project = new LdtkProject();
		level = project.all_worlds.Default.getLevel(levelID);
		final levelWidth:Int = level.pxWid;
		final levelHeight:Int = level.pxHei;

		// FlxEcho.init({
		// 	x: 0,
		// 	y: 0,
		// 	width: levelWidth,
		// 	height: levelHeight,
		// 	gravity_y: 800
		// });
		// FlxEcho.draw_debug = true;

        camGame = new FlxCamera();
        camGame.bgColor = 0;
        FlxG.cameras.reset(camGame);

        camUI = new FlxCamera();
        camUI.bgColor = 0;
        FlxG.cameras.add(camUI, false);

        uiGroup = new FlxGroup();
        add(uiGroup);

		player = new Player();
		add(player);

		initTilemap();

		trajectory = new Trajectory(15, 2.5);
		trajectory.exists = false;
		add(trajectory);

        FlxG.camera.follow(player, PLATFORMER, 1);
		FlxG.worldBounds.set(0, 0, levelWidth, levelHeight);
		FlxG.camera.setScrollBounds(0, levelWidth, -CAMERA_PADDING, levelHeight + CAMERA_PADDING);

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
		arrowD.y = FlxG.height - arrowD.height + 20;
        cameraViewGroup.add(arrowD);

        var arrowU:FlxSprite = arrowD.clone();
        arrowU.angle = 90;
        arrowU.screenCenter(X);
		arrowU.y = -20;
        cameraViewGroup.add(arrowU);
    }

    override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(entities, tilemap, (a:Entity, b:FlxTilemapExt) -> a.onCollision(b));
		FlxG.collide(player, tilemap);
		FlxG.overlap(player, entities, (a:Player, b:Entity) ->
		{
			a.onOverlap(b);
			b.onOverlap(a);
		});

		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}

        if (FlxG.keys.justPressed.ENTER)
        {
            // camGame.updateMovement = !camGame.updateMovement;
            // player.updateMovement = !camGame.updateMovement;
            cameraViewMode = !cameraViewMode;
			player.canMove = !cameraViewMode;
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
		tilemap = new FlxTilemapExt();
		tilemap.setDownwardsGlue(true);
		add(tilemap);

		final tiles = level.l_Tiles;
		final tileArray = LdtkUtil.createTileArray(tiles);
		tilemap.loadMapFromArray(tileArray, tiles.cWid, tiles.cHei, "assets/images/tilestest.png", tiles.gridSize, tiles.gridSize, null, 0, 0);

        // air tiles are literally empty so no need to draw them
		var airTilePos = tilemap.getAllTilePos(0);
        for (pos in airTilePos)
        {
            var tile = tilemap.getTileData(pos);
            tile.ignoreDrawDebug = true;
        }

		entities = new FlxTypedGroup<Entity>();
		add(entities);

		for (ldtkEntity in level.l_Entities.getAllUntyped())
		{
			switch (ldtkEntity.identifier.toLowerCase())
			{
				case "playerspawnpos":
					player.setPosition(ldtkEntity.pixelX, ldtkEntity.pixelY);
				case "mushroom": entities.add(new Mushroom(ldtkEntity.pixelX, ldtkEntity.pixelY));
                case "mainflower": entities.add(new MainFlower(ldtkEntity.pixelX, ldtkEntity.pixelY));
				case "exitarea":
					entities.add(new ExitArea(ldtkEntity.pixelX, ldtkEntity.pixelY));
				default:
					FlxG.log.warn('Unhandled entity ${ldtkEntity.identifier}');
			}
		}
	}

    var runningCutscene:Bool = false;
	public function runExitCutscene():Void
	{
        if (runningCutscene)
            return;

        runningCutscene = true;
		player.canMove = false;
        player.velocity.x = 0;
		// player.acceleration.y = 0;
		FlxTimer.wait(2, () ->
		{
			var vinesPos = tilemap.getAllTilePos(8);
			for (pos in vinesPos)
				var t = tilemap.setTileIndex(pos, 0);

			camUI.fade();
			camGame.fade();
			player.velocity.x = 200;
            FlxTimer.wait(2, () -> FlxG.switchState(PlayState.new.bind(getNextLevel())));
		});
	}
    
	function getNextLevel():String
	{
		return "Level_0";
	}
}
