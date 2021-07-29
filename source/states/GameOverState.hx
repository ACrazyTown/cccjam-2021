package states;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import utils.Paths;
import flixel.FlxG;

import utils.Conductor;

class GameOverState extends BeatState
{
    var isSus:Bool = false;

    override function create()
    {
        super.create();

        if (FlxG.random.bool(0.1))
        {
            isSus = true;
        }

        if (FlxG.sound.music.playing)
            FlxG.sound.music.stop();

        var drip:FlxSprite = new FlxSprite().loadGraphic("assets/images/drip.png");
        drip.alpha = 0;
        add(drip);

        var gameOver:FlxText = new FlxText(0, 120, 0, "Job Failed Successfully \n(GAME OVER)", 64);
        gameOver.alignment = FlxTextAlign.CENTER;
        gameOver.screenCenter(X);
        gameOver.alpha = 0;
        add(gameOver);

        var txt:FlxText = new FlxText(0, gameOver.y + 120, 0, "Press ANY KEY to return to the Menu", 42);
        txt.alpha = 0;
        add(txt);

        Conductor.changeBPM(70);

        trace("SUS MUSIC? " + isSus);

        switch (isSus)
        {
            case true:
                FlxG.sound.playMusic("assets/music/game_over_sus_version" + Paths.SOUND_EXT, 0);

            case false:
				FlxG.sound.playMusic("assets/music/game_over" + Paths.SOUND_EXT, 0);
        }

        FlxG.sound.music.fadeIn(2, 0, 1);

        new FlxTimer().start(1.75, function(tmr:FlxTimer)
        {
            FlxTween.tween(gameOver, {alpha: 1.0}, 1.75);
        });

		new FlxTimer().start(2.25, function(tmr:FlxTimer)
		{
			FlxTween.tween(txt, {alpha: 1.0}, 1.75);
		});
        
        if (isSus)
        {
			new FlxTimer().start(2.75, function(tmr:FlxTimer)
			{
				FlxTween.tween(drip, {alpha: 0.10}, 1.75);
			});
        }
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        Conductor.songPosition = FlxG.sound.music.time;

        everyStep();
        everyBeat();

        if (FlxG.keys.justPressed.ANY)
        {
            FlxG.switchState(new IntroState());
        }
    }
}