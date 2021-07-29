package states.substates;

import props.Player;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

class InventorySubstate extends BeatSubstate
{
    var allowInputs:Bool = true;

	var equipText:FlxText;

	var bombIcon:FlxSprite;

    public function new()
    {
        super();

        #if FLX_MOUSE
        if (!FlxG.mouse.enabled)
            FlxG.mouse.enabled = true;
        #end

        var iconTex:FlxAtlasFrames = FlxAtlasFrames.fromSparrow("assets/images/items.png", "assets/images/items.xml");

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.7;
        add(bg);

        bombIcon = new FlxSprite();
        bombIcon.frames = iconTex;
        bombIcon.animation.addByPrefix("selected", "bomb Item Highlighted", 24, false);
        bombIcon.animation.addByPrefix("pressed", "bomb Item Pressed", 24, false);
        bombIcon.antialiasing = true;
        bombIcon.screenCenter();
        bombIcon.animation.play("selected");
        add(bombIcon);

        // hard coded for now since there's no other items!
		equipText = new FlxText(bombIcon.x, (bombIcon.y - 70), 0, "Equipped BOMB!", 28);
        equipText.alpha = 0;
        add(equipText);

        var controlsTxt:FlxText = new FlxText(0, (FlxG.height - 80), 0, "Press ENTER to equip the selected item!", 24);
        controlsTxt.alpha = 0.65;
        controlsTxt.screenCenter(X);
        add(controlsTxt);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (bombIcon.animation.curAnim.name == "selected")
        {
            bombIcon.offset.x = -10;
            bombIcon.offset.y = -10;
        }

        if (FlxG.keys.justPressed.ENTER && allowInputs)
        {
            allowInputs = true;

			bombIcon.offset.x = 0;
			bombIcon.offset.y = 0;
            bombIcon.animation.play("pressed");
            showEquipText();

            Player.selectedItem = "bomb";

            new FlxTimer().start(4, function(tmr:FlxTimer)
            {
                close();
            });
        }

        if (FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]))
        {
            close();
        }
    }

    function showEquipText()
    {
		FlxTween.tween(equipText, {alpha: 1.0, y: (bombIcon.y - 80)}, 1.75);
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
			FlxTween.tween(equipText, {alpha: 0, y: (bombIcon.y - 70)}, 1.75);
        });
    }
}