package states.substates;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class PauseSubstate extends BeatSubstate
{
    var pausedMusic:Bool = false;

    public function new()
    {
        super();

        if (FlxG.sound.music.playing)
            FlxG.sound.music.pause();
            pausedMusic = true;

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.7;
        add(bg);

        var pausedTxt:FlxText = new FlxText(0, 120, 0, "PAUSED", 64);
        pausedTxt.screenCenter(X);
        add(pausedTxt);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
        {
            if (pausedMusic)
                FlxG.sound.music.resume();

            close();
        }
    }
}