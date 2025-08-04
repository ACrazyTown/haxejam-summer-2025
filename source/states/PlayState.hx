package states;

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

class PlayState extends FlxState
{
    var levelID:String;
    var project:LdtkProject;

    var camGame:FlxCamera;
    var camUI:FlxCamera;

    var uiGroup:FlxGroup;

    var tilemap:FlxSpriteGroup;
    var collisionMap:FlxTilemap;

    var player:Player;

    var cameraViewMoveSpeed:Int = 300;
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
        // camGame = new ControllableCamera();
        camGame = new FlxCamera();
        camGame.bgColor = 0;
        FlxG.cameras.reset(camGame);

        camUI = new FlxCamera();
        camUI.bgColor = 0;
        FlxG.cameras.add(camUI, false);

        uiGroup = new FlxGroup();
        add(uiGroup);

        project = new LdtkProject();
        var level = project.all_worlds.Default.getLevel(levelID);

        tilemap = new FlxSpriteGroup();
        add(tilemap);
        level.l_Tiles.render(tilemap);

        collisionMap = new FlxTilemap();
        collisionMap.loadMapFromArray(level.l_IntGrid.json.intGridCsv, level.l_IntGrid.cWid, level.l_IntGrid.cHei, "assets/images/tilestest.png", 60, 60);
        collisionMap.alpha = 0.3;
        add(collisionMap);

        var spawnPos = level.l_Entities.all_PlayerSpawnPos[0];
        player = new Player(spawnPos.pixelX, spawnPos.pixelY);
        add(player);

        FlxG.camera.follow(player, PLATFORMER, 1);
        FlxG.worldBounds.set(0, 0, level.l_Tiles.pxWid, level.l_Tiles.pxHei);
        FlxG.camera.setScrollBounds(0, level.l_Tiles.pxWid, 0, level.l_Tiles.pxHei);

        // camera view mode
        cameraViewGroup = new FlxGroup();
        cameraViewGroup.camera = camUI;
        cameraViewGroup.visible = false;
        add(cameraViewGroup);

        cameraViewObject = new FlxObject();
        add(cameraViewObject);

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
    }

    override public function update(elapsed:Float)
    {
        // FlxG.collide(player, collisionMap);
        super.update(elapsed);
        FlxG.collide(player, collisionMap);

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
}
