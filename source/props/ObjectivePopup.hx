package props;

import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;

class Objective extends FlxSpriteGroup
{
    public var objectiveTxt:FlxText;

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(375, 115, FlxColor.BLACK);
        bg.alpha = 0.45;
        add(bg);

        var txt:FlxText = new FlxText((bg.x + 20), (bg.y + 20), 0, "OBJECTIVE:", 24);
        add(txt);

        objectiveTxt = new FlxText(txt.x, (txt.y + 30), 0, "", 24);
        add(objectiveTxt);
    }
}

class ObjectivePopup extends FlxSpriteGroup
{
    public var roomCompleted:Bool = false;
    public var road1Completed:Bool = false;

    public var road2Mission:Bool = false;
	public var road2Completed:Bool = false;

    var showed:Bool = false;

    var objective:Objective;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        objective = new Objective();
        objective.screenCenter(X);
        objective.alpha = 0;
        add(objective);
    }

    public function setText(txt:String)
    {
        objective.objectiveTxt.text = txt;
    }

    public function show(?timerTime:Float)
    {
        var time:Float;

        if (timerTime != null)
            time = timerTime;
        else
            time = 2;

        new FlxTimer().start(time, function(tmr:FlxTimer)
        {
            FlxTween.tween(objective, {alpha: 1.0}, time);
            showed = true;
        });
    }

    public function hide(?timerTime:Float)
    {
        objective.objectiveTxt.text = "COMPLETED!";

		var time:Float;

		if (timerTime != null)
			time = timerTime;
		else
			time = 2;

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			FlxTween.tween(objective, {alpha: 0}, time);
			showed = false;
		});
    }
}