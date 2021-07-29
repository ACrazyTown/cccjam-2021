package props;

import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

class InteractionPopup extends FlxSpriteGroup
{
    public var overlapObject:String = "";
    
    public var useable:Bool = false;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        setPosition(x, y);

        var keyTxt:FlxText = new FlxText(x, y, 0, "[E]", 24);
        keyTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5);
        add(keyTxt);
    }

    public function updatePosition(parent:FlxObject)
    {
        this.x = (parent.x - 65) + 100; // -65 because the Player has an offset
        this.y = (parent.y - 180);
    }
}