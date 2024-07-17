package states;

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;

import haxe.Json;
import openfl.display.BitmapData;
import openfl.Assets;

class TitleState extends MusicBeatState
{
	public static var initialized:Bool = false;
	public static var closedState:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	
	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];
	var wackyImage:FlxSprite;

	var bgGrad:FlxSprite;
	var logoBumping:FlxSprite;
	var titleText:FlxSprite;

	//BF DANCE
	var bfDance:FlxSprite;
	var danceLeft:Bool = false;

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		super.create();

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
			}

			if(FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxG.sound.music.fadeIn(1.5, 0, 1);
			}

			persistentUpdate = true;
			persistentDraw = true;

			initialized = true;
		}

		Conductor.bpm = 102;

		FlxG.mouse.visible = false;
		FlxG.camera.fade(FlxColor.BLACK, 3, true);

		bgGrad = new FlxSprite().loadGraphic(Paths.image('menus/titleScreen/titleBG'));
		bgGrad.antialiasing = ClientPrefs.data.antialiasing;
		add(bgGrad);

		logoBumping = new FlxSprite(-15, -25);
		logoBumping.frames = Paths.getSparrowAtlas('menus/titleScreen/logoBumpin');
		logoBumping.antialiasing = ClientPrefs.data.antialiasing;
		logoBumping.setGraphicSize(Std.int(logoBumping.width * 0.85));
		logoBumping.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBumping.animation.play('bump');
		logoBumping.updateHitbox();
		add(logoBumping);

		bfDance = new FlxSprite(680, 205);
		bfDance.frames = Paths.getSparrowAtlas('menus/titleScreen/bfDanceTitle');
		bfDance.animation.addByIndices('danceLeft', 'BF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		bfDance.animation.addByIndices('danceRight', 'BF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		bfDance.antialiasing = ClientPrefs.data.antialiasing;
		add(bfDance);

		titleText = new FlxSprite(200, 450);
		titleText.frames = Paths.getSparrowAtlas('menus/titleScreen/titleEnter');
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}
		
		if (animFrames.length > 0) {
			newTitle = true;
			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else {
			newTitle = false;
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}
		titleText.animation.play('idle');
		titleText.antialiasing = ClientPrefs.data.antialiasing;
		titleText.setGraphicSize(Std.int(titleText.width * 0.5));
		titleText.updateHitbox();
		titleText.screenCenter();
		titleText.x -= 170;
		titleText.y += 160;
		add(titleText);
	}

	var transitioning:Bool = false;
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.F11)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;
		
		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;
		}
		
		if (newTitle) {
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		if (initialized && !transitioning)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}
			
			if(pressedEnter)
			{
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			}
		}
		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		if(logoBumping != null)
			logoBumping.animation.play('bump', true);

		if(bfDance != null) {
			danceLeft = !danceLeft;
			if (danceLeft)
				bfDance.animation.play('danceRight');
			else
				bfDance.animation.play('danceLeft');
		}
	}
}