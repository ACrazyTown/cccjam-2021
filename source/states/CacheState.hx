package states;

import sys.thread.Thread;
import sys.FileSystem;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

using StringTools;

class CacheState extends FlxState
{
	var loadingText:FlxText;

	override public function create()
	{
		loadingText = new FlxText(0, 0, 0, "Loading...", 32);
		loadingText.screenCenter();
		add(loadingText);

		Thread.create(() ->
		{
			cache();
		});
	}

	function cache()
	{
		var imageList = [];
        var musicList = [];

		trace("Caching Graphics...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
		{
			if (!i.endsWith(".png"))
				continue;
			imageList.push(i);
		}

		for (i in imageList)
		{
			FlxG.bitmap.add("assets/images/" + i);
			trace("Cached: " + i);
		}

		trace("Caching Music...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/music")))
		{
            musicList.push(i);
        }

        for (i in musicList)
        {
            FlxG.sound.cache("assets/music/" + i);
            trace("Cached: " + i);
        }

		trace("Cached all Music!");

		loadingText.destroy();
		FlxG.switchState(new IntroState());
	}
}