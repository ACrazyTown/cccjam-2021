package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.TransitionData;

import states.PlayState;

import utils.Paths;
import utils.Conductor;

class IntroState extends BeatState
{
    public static var firstTime:Bool = true;

    var skippedIntro:Bool = false;

    var introText:FlxText;
    var cccJamLogo:FlxSprite;

    override function create()
    {
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        super.create();

		introText = new FlxText(0, 0, 0, "A CRAZY TOWN & DESPAWNEDDIAMOND", 32);
        repositionText();
        add(introText);

		Conductor.changeBPM(130);

        FlxG.sound.playMusic("assets/music/intro_first_part" + Paths.SOUND_EXT, 0.70, false);
        FlxG.sound.music.onComplete = () ->
        {
            FlxG.sound.playMusic("assets/music/intro_loop" + Paths.SOUND_EXT, 0.70, true);
			FlxG.sound.music.onComplete = () ->
			{
				resetValues();
			};
        };
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (!FlxG.sound.music.playing)
		    FlxG.sound.playMusic("assets/music/intro_loop" + Paths.SOUND_EXT, 0.85, true);
            FlxG.sound.music.onComplete = () ->
            {
                resetValues();
            };

        Conductor.songPosition = FlxG.sound.music.time;

        everyStep();
        everyBeat();

        if (skippedIntro)
        {
            if (FlxG.keys.justPressed.ENTER)
            {
                FlxG.switchState(new PlayState());
                FlxG.sound.music.fadeOut(0.75, 0, onComplete -> { FlxG.sound.music.stop();});
            }
        }
        else
        {
            if (FlxG.keys.justPressed.ENTER)
            {
                skipIntro();
            }
        }
    }

    override function customBeatHit():Void
    {
        switch(curBeat)
        {
            case 6:
                addText("PRESENT");
            case 8:
                deleteText();
                changeText("A GAME FOR");
            case 12:
				addText("CCC JAM 2.0");
            case 16:
                deleteText();
                changeText("WAY TOO LATE");
            case 22:
                addText("BUT WHATEVER");
            case 24:
                deleteText();
                changeText("TOOK TOO LONG");
            case 28:
                addText("I WANT TO CRY");
            case 32:
                skipIntro();
        }
    }

    function skipIntro()
    {
        skippedIntro = true;
        remove(cccJamLogo);
        remove(introText);
        FlxG.camera.flash(FlxColor.WHITE, 3.25);
        showMenu();
    }

    function showMenu()
    {
        var logo:FlxText = new FlxText(0, 100, 0, "JOB FAILED \nSUCCESSFULLY", 64);
        logo.alignment = FlxTextAlign.CENTER;
        logo.screenCenter(X);
        add(logo);

        var versionTxt:FlxText = new FlxText(20, FlxG.height - 20, 0, "0.1.0 [JAM PROTOTYPE]", 24);
        versionTxt.alpha = 0.85;
        add(versionTxt);

        var playBtn:FlxText = new FlxText(0, 0, 0, "PLAY", 48);
        playBtn.color = FlxColor.YELLOW;
        playBtn.screenCenter();
        add(playBtn);
    }

    function changeText(txt:String)
    {
		introText.text = txt;
        repositionText();
    }

    function addText(txt:String)
    {
        introText.text += "\n" + txt;
        repositionText();
    }

    function deleteText()
    {
        introText.text = "";
    }

    function repositionText()
    {
        introText.screenCenter();
        introText.alignment = FlxTextAlign.CENTER;
    }
}