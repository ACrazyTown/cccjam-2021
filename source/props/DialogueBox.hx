package props;

import flixel.tweens.FlxTween;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

class DialogueBox extends FlxSpriteGroup
{
    public static var ended:Bool = false;

    var opened:Bool = false;
    var started:Bool = false;

    var dialogueList:Array<String> = [];
    var dialogueIndex:Int = -1;
    var curDialogue = "";

    var typeText:FlxTypeText;
    var box:FlxSprite;
	var overlay:FlxSprite;

    public function new(dialogue:String)
    {
        super();

        // 134, 407

        overlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.alpha = 0.25;
        add(overlay);

        box = new FlxSprite(134, 407);
        box.frames = FlxAtlasFrames.fromSparrow("assets/images/messageBox.png", "assets/images/messageBox.xml");
        box.animation.addByPrefix("open", "message box appear", 24, false);
        box.animation.addByPrefix("idle", "message box", 24, false);

        box.antialiasing = true;
        box.animation.play("open");
        opened = true;
		add(box);

        typeText = new FlxTypeText(190, 420, Std.int(box.width - 80), "", 28);
        typeText.color = FlxColor.WHITE;
		add(typeText);

        switch (dialogue)
        {
            case "room":
                dialogueList = ["Eughh...", "I really don't want to go to work today...", "It's just so... boring...", "Hmmm...", "I know!", "I'll skip work by just DESTROYING my workplace!", "Yeah!"];

            default:
                dialogueList = ["Something goofed up bro. Contact the devs."];
        }

        startDialogue();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (opened && FlxG.keys.justPressed.ENTER)
        {
            trace(dialogueList.length);
            trace(dialogueIndex);
            if (dialogueIndex == (dialogueList.length - 1))
                endDialogue();
            else
                startDialogue();
        }
    }

    function startDialogue():Void
    {
        cleanDialogue();

        typeText.resetText(dialogueList[dialogueIndex]);
        typeText.start(0.05, true);
    }

    function cleanDialogue():Void
    {
        dialogueIndex++;
    }

    function endDialogue():Void
    {
		ended = true;

        FlxTween.tween(overlay, {alpha: 0}, 2.25);
        FlxTween.tween(box, {alpha: 0}, 2.25);
        FlxTween.tween(typeText, {alpha: 0}, 2.25);

        remove(overlay);
        remove(box);
        remove(typeText);
    }
}