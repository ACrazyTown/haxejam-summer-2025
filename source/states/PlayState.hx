package states;

import props.Teleporter;
import props.BreakableBlock;
import ldtk.Json.EntityReferenceInfos;
import props.DepositKey;
import props.PlantKey;
import ldtk.Json.EntityInstanceJson;
import props.BlockKey;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.tile.FlxTilemap;
import props.PlantPlatform;
import props.PlantSafeland;
import flixel.math.FlxPoint;
import props.FloatingPlatform;
import data.Controls;
import util.Constants;
import props.FloatingIsland;
import props.Rose as RoseProp;
import props.Pot;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import props.ExitArea;
import ui.trajectory.Trajectory;
import props.Mushroom;
import props.Entity;
import flixel.addons.tile.FlxTilemapExt;
import util.LdtkUtil;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.FlxG;
import data.LdtkProject;
import props.Player;
import flixel.FlxState;
import flixel.text.FlxText;

// using echo.FlxEcho;

class PlayState extends FlxState
{
    public static var instance:PlayState;

    var levelID:String;
    var levelNum:Int;
    var project:LdtkProject;
	var level:LdtkProject_Level;

    var camGame:FlxCamera;
    var camUI:FlxCamera;

    var uiGroup:FlxGroup;
	var controlsText:FlxBitmapText;

	public var tilemap:FlxTilemap;

	var entities:FlxTypedGroup<Entity>;
	var walls:FlxTypedGroup<FlxObject>;

	public var player:Player;

	public var trajectory:Trajectory;

	var cameraViewMoveSpeed:Int = 400;
    public var cameraViewMode:Bool;
    var cameraViewObject:FlxObject;
    var cameraViewGroup:FlxGroup;

	final CAMERA_PADDING:Int = 0;

	var runningCutscene:Bool = false;

	var overlay:FlxSprite;

    public function new(level:String)
    {
        super();
        instance = this;

        this.levelID = level;
		this.levelNum = Std.parseInt(levelID.split("_")[1]);
    }

    override public function create()
    {
        super.create();

		project = new LdtkProject();
		level = project.all_worlds.Default.getLevel(levelID);
		final levelWidth:Int = level.pxWid;
		final levelHeight:Int = level.pxHei;

        camGame = new FlxCamera();
		camGame.bgColor = 0xFF6D546D;
        camGame.pixelPerfectRender = true;
        FlxG.cameras.reset(camGame);

        camUI = new FlxCamera();
        camUI.bgColor = 0;
        FlxG.cameras.add(camUI, false);

		FlxG.worldBounds.set(-1, -1, levelWidth + 1, levelHeight + 1);
		FlxG.camera.setScrollBounds(0, levelWidth, -CAMERA_PADDING, levelHeight + CAMERA_PADDING);

        uiGroup = new FlxGroup();
        add(uiGroup);

		controlsText = new FlxBitmapText(5, 10, "", FlxBitmapFont.fromAngelCode("assets/font/badpixelz.png", "assets/font/badpixelz.xml"));
		controlsText.scrollFactor.set();
		controlsText.camera = camUI;
		controlsText.setBorderStyle(SHADOW, FlxColor.BLACK, 2);
		controlsText.lineSpacing = 4;
		updateControlsText();
		add(controlsText);

		player = new Player();
		add(player);

		FlxG.camera.follow(player, PLATFORMER, 1);

		initTilemap();

		trajectory = new Trajectory(15, 2.5);
		trajectory.exists = false;
		add(trajectory);

		createWalls();

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
		overlay = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.BLACK);
		overlay.scale.set(FlxG.width * 2, FlxG.height * 2);
		overlay.scrollFactor.set(0, 0);
		add(overlay);

        if (!FlxG.sound.music?.playing)
            FlxG.sound.playMusic("assets/music/songloop", 0.7);
		FlxTween.tween(overlay, {alpha: 0});
    }

    override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, walls);
		FlxG.collide(entities, walls);
        
		FlxG.collide(player, tilemap, (a:Player, b:FlxTilemap) -> a.onCollision(b));
		FlxG.collide(entities, tilemap, (a:Entity, b:FlxTilemap) -> a.onCollision(b));

		FlxG.overlap(player, entities, (a:Player, b:Entity) ->
		{
			a.onOverlap(b);
			b.onOverlap(a);
		});

		FlxG.overlap(entities, entities, (a:Entity, b:Entity) ->
		{
			a.onOverlap(b);
			b.onOverlap(a);
		});

		if (player.y > level.pxHei + player.height + 100)
			die();

		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.ENTER && !runningCutscene)
        {
            // camGame.updateMovement = !camGame.updateMovement;
            // player.updateMovement = !camGame.updateMovement;
            cameraViewMode = !cameraViewMode;
			player.canMove = !cameraViewMode;
            cameraViewGroup.visible = cameraViewMode;
			updateControlsText();

            FlxG.camera.target = cameraViewMode ? null : player;
        }

        if (cameraViewMode)
        {
            if (FlxG.keys.anyPressed(Controls.LEFT))
                camera.scroll.x -= cameraViewMoveSpeed * elapsed;
			if (FlxG.keys.anyPressed(Controls.RIGHT))
                camera.scroll.x += cameraViewMoveSpeed * elapsed;
			if (FlxG.keys.anyPressed(Controls.UP))
                camera.scroll.y -= cameraViewMoveSpeed * elapsed;
			if (FlxG.keys.anyPressed(Controls.DOWN))
                camera.scroll.y += cameraViewMoveSpeed * elapsed;
        }
    }

	function initTilemap():Void
	{
		tilemap = new FlxTilemap();
		// tilemap.setDownwardsGlue(true);
        tilemap.framePadding = 0; // having frame padding crashes on HTML5?
		add(tilemap);

		final tiles = level.l_Tiles;
		final tileArray = LdtkUtil.createTileArray(tiles);
		tilemap.loadMapFromArray(tileArray, tiles.cWid, tiles.cHei, "assets/images/tilestest2.png", tiles.gridSize, tiles.gridSize, null, 0, 0);
        tilemap.setTileProperties(16, NONE);

		#if debug
        // air tiles are literally empty so no need to draw them
		var airTilePos = tilemap.getAllTilePos(0);
        for (pos in airTilePos)
        {
            var tile = tilemap.getTileData(pos);
            tile.ignoreDrawDebug = true;
        }
        #end

		entities = new FlxTypedGroup<Entity>();
		add(entities);

		for (ldtkEntity in level.l_Entities.getAllUntyped())
		{
			var id = ldtkEntity.identifier.toLowerCase();
			switch (id)
			{
				case "playerspawnpos":
					player.setPosition(ldtkEntity.pixelX, ldtkEntity.pixelY);
				case "mushroom":
					entities.add(new Mushroom(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY));
				case "rose":
					var r = new RoseProp(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY);
					entities.add(r);

					if (levelNum > 0)
					{
						player.carried = r;
						player.carried.carried = true;
						player.carried.carrier = player;
					}
				case "exitarea":
					entities.add(new ExitArea(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY));
				case "pot":
					entities.add(new Pot(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY));
				case "floatingisland":
					entities.add(new FloatingIsland(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY));
                case "floatingplatform", "floatingplatformwide":
                    var endPosX:Null<Float> = null;
                    var endPosY:Null<Float> = null;
                    for (fi in ldtkEntity.json.fieldInstances)
                    {
                        if (fi.__identifier == "endX")
                            endPosX = fi.__value;
                        if (fi.__identifier == "endY")
                            endPosY = fi.__value;
                    }

                    var wide:Bool = id == "floatingplatformwide";
					var platform = new FloatingPlatform(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY, wide,
						FlxPoint.get(endPosX ?? ldtkEntity.pixelX, endPosY ?? ldtkEntity.pixelY));
                    entities.add(platform);
				case "plantsafelanding":
					entities.add(new PlantSafeland(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY));
				case "plantplatform":
                    var height:Null<Float> = null;
					for (fi in ldtkEntity.json.fieldInstances)
					{
						if (fi.__identifier == "height")
							height = fi.__value;
					}

					entities.add(new PlantPlatform(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY, height));
				case "blockkey", "blockkeyrev":
					var parent:Null<EntityReferenceInfos> = null;
					for (fi in ldtkEntity.json.fieldInstances)
					{
						if (fi.__identifier == "parent")
							parent = fi.__value;
					}

					if (parent != null)
					{
						var reverse:Bool = id == "blockkeyrev";
						entities.add(new BlockKey(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY, parent, reverse));
					}
					else
						FlxG.log.warn("Parentless block found");
				case "plantkey":
					entities.add(new PlantKey(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY));
				case "depositkey":
					var key:Null<EntityReferenceInfos> = null;
					for (fi in ldtkEntity.json.fieldInstances)
					{
						trace(fi);
						if (fi.__identifier == "key")
							key = fi.__value;
					}

					trace(key);

					if (key != null)
					{
						entities.add(new DepositKey(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY, key));
					}
					else
						FlxG.log.warn("Keyless deposit found");
				case "blockbreakable":
					entities.add(new BreakableBlock(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY));
				case "teleporter":
					var x:Null<Float> = null;
					var y:Null<Float> = null;
					for (fi in ldtkEntity.json.fieldInstances)
					{
						if (fi.__identifier == "x")
							x = fi.__value;
						if (fi.__identifier == "y")
							y = fi.__value;
					}

					var teleporter = new Teleporter(ldtkEntity, ldtkEntity.pixelX, ldtkEntity.pixelY, FlxPoint.get(x, y));
					entities.add(teleporter);
				default:
					FlxG.log.warn('Unhandled entity ${ldtkEntity.identifier}');
			}
		}

		for (entity in entities)
		{
			if (entity is BlockKey)
				cast(entity, BlockKey).findParent(entities);
			if (entity is DepositKey)
				cast(entity, DepositKey).findParent(entities);
		}
	}

	function createWalls():Void
	{
		walls = new FlxTypedGroup<FlxObject>();
		add(walls);

		var wallL:FlxObject = new FlxObject(-1, 0, 1, level.pxHei);
		wallL.active = false;
		wallL.immovable = true;
		walls.add(wallL);

		var wallU:FlxObject = new FlxObject(0, -1, level.pxWid, 1);
		wallU.active = false;
		wallU.immovable = true;
		walls.add(wallU);

		// var wallD:FlxObject = new FlxObject(0, level.pxHei + 1, level.pxWid, 1);
		// wallD.active = false;
		// wallD.immovable = true;
		// walls.add(wallD);
	}

	public function runExitCutscene():Void
	{
        if (runningCutscene)
            return;

		runningCutscene = true;

		var vinesPos = tilemap.getAllTilePos(18);
		for (pos in vinesPos)
			tilemap.setTileIndex(pos, 0);

		cameraViewMode = false;
		cameraViewGroup.visible = false;
        FlxG.camera.target = player;

		player.canMove = false;
		player.animation.play("walkR");
		player.animation.curAnim.looped = true;
		player.velocity.x = Constants.PLAYER_WALK_VELOCITY / 2;

		FlxTween.tween(overlay, {alpha: 1}, 2);
		FlxTimer.wait(3, () ->
		{
			var nextLevel = levelNum + 1;
			var nextState = nextLevel > 10 ? PlayState.new.bind("TODO") : PlayState.new.bind('Level_$nextLevel');
			FlxG.switchState(nextState);
		});
	}

	public function die():Void
	{
		if (runningCutscene)
			return;

		runningCutscene = true;

		FlxTween.tween(overlay, {alpha: 1}, 1, {onComplete: (_) -> FlxG.resetState()});
	}

	function updateControlsText():Void
	{
		if (cameraViewMode)
		{
			controlsText.text = "[ENTER] Return to gameplay";
		}
		else
		{
			controlsText.text = '[R] Restart level\n[ENTER] Look around\n[SPACE] Interact';
		}
	}
}
