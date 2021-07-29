package props;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;

import utils.Paths;

using StringTools;

class Player extends FlxSprite
{
    public static var vel:Int = 125;
    public static var selectedItem:String = "";

    public function new(x:Float, y:Float)
    {
        super(x, y);

		frames = FlxAtlasFrames.fromSparrow("assets/images/player.png", "assets/images/player.xml");
		animation.addByPrefix("idle", "guy Idle", 24, false);
		animation.addByPrefix("walk", "guy Walk", 24);
		animation.addByPrefix("yolo", "guy YOLO", 24, false);
		animation.addByPrefix("bombthrow", "guy YOLO Bomb", 24, false);
        setGraphicSize(Std.int(200));
		antialiasing = true;

        animation.play("idle", true);

        fixHitboxes();
    }

    public function updateMovement()
    {
		var left:Bool = FlxG.keys.anyPressed([LEFT, A]);
		var right:Bool = FlxG.keys.anyPressed([RIGHT, D]);

        velocity.set(0, 0);

        if (left || right)
        {
            if (left)
            {
                flipX = true;
				velocity.x = -vel;
            }
            else
            {
                flipX = false;
				velocity.x = vel;
            }

			animation.play("walk");
        }

        /*
		walking = false;
		player.velocity.x = 0;

		if (FlxG.keys.anyPressed([LEFT, A]))
			player.velocity.x = -Player.vel;
		player.animation.play("walk");
		player.flipX = true;
		walking = true;

		if (FlxG.keys.anyPressed([RIGHT, D]))
			player.velocity.x = Player.vel;
		player.animation.play("walk");
		player.flipX = false;
		walking = true;
        */
    }

	public function fixHitboxes()
	{
		if (flipX)
		{
			width = 80;
			offset.x = 85;
		}
		else
		{
			width = 80;
			offset.x = 65;
		}
    }

	public function setVelocity(type:String)
	{
		switch (type)
		{
			case "normal":
				vel = 125;
			
			case "run":
				vel = 160;
		}
	}
}