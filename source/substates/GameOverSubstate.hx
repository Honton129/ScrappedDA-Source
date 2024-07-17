package substates;

import objects.cutscenes.*;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Character;
	var camFollow:FlxObject;
	var moveCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';
	
	public static var instance:GameOverSubstate;

	var dialogue:Array<String> = ['blah blah blah :v', 'coolswag B)'];
	var inDialogue:Bool = false;

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';

		var _song = PlayState.SONG;
		if(_song != null)
		{
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
			if(_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0) loopSoundName = _song.gameOverLoop;
			if(_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0) endSoundName = _song.gameOverEnd;
		}
		DialogueBoxGameOver.onPlayState = false;
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnScripts('onGameOverStart', []);

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		PlayState.instance.setOnScripts('inGameOver', true);

		Conductor.bpm = 100;
		Conductor.songPosition = 0;

		boyfriend = new Character(x, y, characterName, true);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		add(boyfriend);

		if(PlayState.SONG.song.toLowerCase() == 'disconnection' ||  PlayState.SONG.song.toLowerCase() == 'short-circuit' || PlayState.SONG.song.toLowerCase() == 'banishment' || PlayState.SONG.song.toLowerCase() == 'savestate')
		{
			boyfriend.alpha = 0;
		}

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x + boyfriend.cameraPosition[0], boyfriend.getGraphicMidpoint().y + boyfriend.cameraPosition[1]);
		FlxG.camera.focusOn(new FlxPoint(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2)));
		add(camFollow);
	}

	public var startedDeath:Bool = false;
	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		if (controls.ACCEPT && !inDialogue)
		{
			endBullshit();
		}

		if (controls.BACK && !inDialogue)
		{
			#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;

			Mods.loadTopMod();

			if(PlayState.isStoryMode) {
				MusicBeatState.switchState(new states.StoryMenuState());
			}
			else
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);

				MusicBeatState.switchState(new states.freeplay.FreeplayState());
				trace('WENT BACK TO FREEPLAY??');	
			}
			PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
		}

		if (boyfriend.animation.curAnim != null)
		{
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
				boyfriend.playAnim('deathLoop');

			if(boyfriend.animation.curAnim.name == 'firstDeath')
			{
				if(boyfriend.animation.curAnim.curFrame >= 12 && !moveCamera)
				{
					FlxG.camera.follow(camFollow, LOCKON, 0.01);
					moveCamera = true;
				}

				if (boyfriend.animation.curAnim.finished && !playingDeathSound)
				{
					startedDeath = true;
					if(PlayState.SONG.song.toLowerCase() == 'blissful-ignorance' || PlayState.SONG.song.toLowerCase() == 'disconnection' ||  PlayState.SONG.song.toLowerCase() == 'short-circuit' || PlayState.SONG.song.toLowerCase() == 'banishment' || PlayState.SONG.song.toLowerCase() == 'savestate') {
						initDoof();
						inDialogue = true;
					} else {
						coolStartDeath();
					}
				}
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
	}

	var isEnding:Bool = false;

	function coolStartDeath():Void
	{
		if(PlayState.SONG.song.toLowerCase() == 'disconnection' ||  PlayState.SONG.song.toLowerCase() == 'short-circuit' || PlayState.SONG.song.toLowerCase() == 'banishment' || PlayState.SONG.song.toLowerCase() == 'savestate')
		{
			FlxTween.tween(boyfriend, {alpha: 1}, 2.5, {
				ease: FlxEase.smoothStepOut,
				onComplete: function (tween:FlxTween)
				{
					FlxG.sound.playMusic(Paths.music(loopSoundName), 1);
					inDialogue = false;
				}
			});
		}
		else
		{
			FlxG.sound.playMusic(Paths.music(loopSoundName), 1);
			inDialogue = false;
		}
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
					DialogueBoxGameOver.onPlayState = true;
				});
			});
			PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
		}
	}

	var doof:DialogueBoxGameOver = null;
	function initDoof()
	{
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'blissful-ignorance':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpaiGameOverEarly')); //The Game-Over dialogue for Senpai week (before Dead-Pixel).
			case 'disconnection' | 'short-circuit' | 'banishment' | 'savestate':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpaiGameOver')); //The Game-Over dialogue for Senpai week (after Senpai-Remix).
		}

		doof = new DialogueBoxGameOver(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = coolStartDeath;
		add(doof);
	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}