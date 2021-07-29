package utils;

import flixel.FlxG;

class Paths
{
    public static var SOUND_EXT = #if web ".mp3" #else ".ogg" #end;

    public static function playMusic(musicName:String, vol:Float, isLooped:Bool)
    {
        var filename:String = "";
        var songBPM:Int = 0;

        switch(musicName)
        {
            case 'morning':
				songBPM = 110;
                filename = "looking_around_woozy";
            case 'looking':
                songBPM = 110;
                filename = "looking_around";
            case 'action':
                songBPM = 150;
                filename = "action_starts";
            case 'gameover':
				songBPM = 70;
                filename = "game_over";
            case 'gameover-sus':
				songBPM = 70;
                filename = "game_over_sus_version";
        }

        Conductor.changeBPM(songBPM);
        trace("Changed BPM!");
        FlxG.sound.playMusic("assets/music/" + filename + SOUND_EXT, vol, isLooped);
    }
}
