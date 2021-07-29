package states;

import states.substates.PauseSubstate;
import states.substates.InventorySubstate;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import utils.Paths;
import utils.Conductor;

import props.Background;
import props.DialogueBox;
import props.ObjectivePopup;
import props.InteractionPopup;
import props.Player;

class PlayState extends BeatState
{
	var inCutscene:Bool = false;
	var walking:Bool = false;

	var normalMusic:Bool = false;

	var background:Background;
	var player:Player;

	var overlay:FlxSprite;
	var dialogueBox:DialogueBox;

	var objectivePopup:ObjectivePopup;
	var interactionPopup:InteractionPopup;

	var collider:FlxSprite;

	var doneCutscene:Bool = false;
	var finalMission:Bool = false;

	override public function create()
	{
		super.create();

		background = new Background();
		background.makeLevel("room");
		add(background);

		player = new Player(80, 0);
		player.screenCenter(Y);
		player.y += 40;
		add(player);

		objectivePopup = new ObjectivePopup(0, 0);
		add(objectivePopup);

		interactionPopup = new InteractionPopup(player.x, (player.y + 80));
		interactionPopup.visible = false;
		add(interactionPopup);

		/*
		switch (background.curRoom)
		{
			case "room":
				collider = new FlxSprite(-64).makeGraphic(64, 128, FlxColor.RED);
				collider.screenCenter(Y);
				add(collider);
		}
		*/

		if (IntroState.firstTime)
		{
			Conductor.changeBPM(110);

			FlxG.sound.playMusic("assets/music/looking_around_woozy" + Paths.SOUND_EXT, 0);
			FlxG.sound.music.fadeIn(2.25, 0, 1);
			FlxG.sound.music.onComplete = () ->
			{
				resetValues();
			};

			introCutscene();
			IntroState.firstTime = false;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		Conductor.songPosition = FlxG.sound.music.time;

		everyStep();
		everyBeat();

		if (player.velocity.x == 0 && player.animation.curAnim.name == "walk")
			player.animation.play("idle", false, false, 15);

		player.fixHitboxes();

		if (!inCutscene)
		{
			player.updateMovement();

			if (FlxG.keys.justPressed.ENTER)
			{
				openSubState(new PauseSubstate());
			}
		}
		else
		{
			if (DialogueBox.ended)
			{
				endIntroCutscene();
			}
		}

		// room specific events and shit
		if (!inCutscene)
		{
			switch (background.curRoom)
			{
				case "room":

					if (finalMission)
					{
						FlxG.switchState(new GameOverState());
					}

					/*
					if (Player.selectedItem == "bomb" && objectivePopup.roomCompleted == false)
						objectivePopup.hide(1.75);
						objectivePopup.roomCompleted = true;
					*/

					if (player.x > 1220)
					{
						if (Player.selectedItem != "")
							stageTransition("road1", "transition");
						else
							player.x = 1220;
					}

					if (player.x < 0)
					{
						player.x = 0;
					}

					if (FlxG.overlap(player, background.closet) && Player.selectedItem == "")
					{
						interactionPopup.useable = true;
						interactionPopup.updatePosition(player);
						interactionPopup.visible = true;
						interactionPopup.overlapObject = "closet";
					}
					else
					{
						interactionPopup.useable = false;
						interactionPopup.visible = false;
						interactionPopup.overlapObject = null;
					}

					if (interactionPopup.useable && FlxG.keys.justPressed.E)
					{
						switch (interactionPopup.overlapObject)
						{
							case "closet":
								openSubState(new InventorySubstate());

							case "bed":
								trace("GAME END WOO!!!");
						}
					}

				case "testroom":
					if (player.x < 0)
					{
						stageTransition("room", "return");
					}

				case "road1":
					if (player.x > 1220)
					{
						stageTransition("road2", "transition");
					}

					if (player.x < 0)
					{
						stageTransition("room", "return");
					}

					/*
					new FlxTimer().start(0.25, function(tmr:FlxTimer)
					{
						objectivePopup.setText("Get to the Office.");
						objectivePopup.show(1.5);
					});
					*/

				case "road2":
					/*
					if (objectivePopup.road1Completed == false)
					{
						objectivePopup.hide();
						objectivePopup.road1Completed = true;
					}
					*/

					if (FlxG.overlap(player, background.blueThing) && doneCutscene == false)
					{
						bombCutscene();

						Conductor.changeBPM(150);
						FlxG.sound.playMusic("assets/music/action_starts" + Paths.SOUND_EXT, 0);
						FlxG.sound.music.fadeIn(1.25, 0, 1);
						FlxG.sound.music.onComplete = () ->
						{
							resetValues();
						}
					}

					if (player.x > 1220)
					{
						stageTransition("road2", "transition");
					}

					if (player.x < 0)
					{
						stageTransition("road1", "return");
					}
			}
		}

	}

	override function customBeatHit():Void
	{
		if (player.velocity.x == 0 && player.animation.curAnim.name != "walk")
			player.animation.stop();
			player.animation.play("idle");
		
	}

	function introCutscene()
	{
		inCutscene = true;

		overlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(overlay);

		FlxTween.tween(overlay, {alpha: 0}, 4);

		new FlxTimer().start(0.75).start(function(tmr:FlxTimer)
		{
			dialogueBox = new DialogueBox("room");
			add(dialogueBox);
		});
	}

	function endIntroCutscene()
	{
		remove(overlay);
		remove(dialogueBox);

		FlxG.sound.music.fadeOut(2.25, 0);

		resetValues();
		FlxG.sound.playMusic("assets/music/looking_around" + Paths.SOUND_EXT, 0);
		FlxG.sound.music.fadeIn(1, 0, 1);
		FlxG.sound.music.onComplete = () -> 
		{
			resetValues();
		};
		normalMusic = true;

		inCutscene = false;

		/*
		new FlxTimer().start(0.25, function(tmr:FlxTimer)
		{
			objectivePopup.setText("Find an item to use.");
			objectivePopup.show(1.5);
		});
		*/
	}

	function bombCutscene()
	{
		FlxG.sound.music.stop();

		inCutscene = true;

		player.velocity.x = 0;
		player.animation.play("bombthrow");

		new FlxTimer().start(1.4, function(tmr:FlxTimer)
		{
			/*
			objectivePopup.setText("Run");
			objectivePopup.show(1.25);
			*/

			background.blueThing.visible = false;

			player.setVelocity("run");

			inCutscene = false;
			doneCutscene = true;

			finalMission = true;
		});
	}

	function stageTransition(nextStage:String, type:String) //types: return, transition 
	{
		inCutscene = true;

		switch (type)
		{
			case "transition":
				player.x = 20;

			case "return":
				player.x = 1220;
		}

		background.makeLevel(nextStage);

		inCutscene = false;
	}
}