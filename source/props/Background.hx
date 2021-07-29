package props;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

class Background extends FlxGroup
{
    public var curRoom:String = "";

	public var bed:FlxSprite;
    public var closet:FlxSprite;
    
    public var blueThing:FlxSprite;

    public function new()
    {
        super();
    }

    public function makeLevel(level:String)
    {
        switch (level)
        {
            case 'room':
                var bg:FlxSprite = new FlxSprite(-40, -28).loadGraphic("assets/images/bg.png");
                add(bg);

                var floor:FlxSprite = new FlxSprite(-44, 523).loadGraphic("assets/images/floor.png");
                add(floor);

                bed = new FlxSprite(0, 350).loadGraphic("assets/images/bed.png");
                add(bed);
                
                var window:FlxSprite = new FlxSprite(519, 134).loadGraphic("assets/images/window.png");
                add(window);

                closet = new FlxSprite(868, 181).loadGraphic("assets/images/closet.png");
                add(closet);

                curRoom = "room";

            case 'road1': //BEE6FB
                var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(190, 230, 251));
                add(bg);

				var building:FlxSprite = new FlxSprite(-109, 138).loadGraphic("assets/images/bg buildings.png");
                add(building);

                var cloud:FlxSprite = new FlxSprite(951, -142).loadGraphic("assets/images/cloud.png");
                add(cloud);

                var road:FlxSprite = new FlxSprite(-34, 492).loadGraphic("assets/images/road.png");
                add(road);

                curRoom = "road1";

            case 'road2':
				var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(190, 230, 251));
				add(bg);

				var cloud:FlxSprite = new FlxSprite(-208, -142).loadGraphic("assets/images/cloud.png");
				add(cloud);

				var road:FlxSprite = new FlxSprite(-34, 492).loadGraphic("assets/images/road.png");
				add(road);

				var office:FlxSprite = new FlxSprite(1219, -80).loadGraphic("assets/images/office.png");
				add(office);

                blueThing = new FlxSprite(803, 0).loadGraphic("assets/images/blueThing.png");
                blueThing.screenCenter(Y);
                blueThing.y += 240;
                add(blueThing);

                curRoom = "road2";

            case 'testroom':
                var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
                add(bg);

                bed = new FlxSprite().loadGraphic("assets/images/bed.png");
                bed.screenCenter();
                add(bed);

                curRoom = "testroom";

            default:
                var txt:FlxText = new FlxText(0, 0, 0, "Something's gone wrong!\n Contact the Devs!", 32);
                txt.screenCenter();
                add(txt);

				curRoom = "error";
        }
    }
}