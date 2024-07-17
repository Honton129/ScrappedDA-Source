package states;

import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;

	//select your victima >:)
	var black:FlxSprite;
	var victimShader:FlxGlitchEffect;
	var victimText:FlxEffectSprite;
	var victimGraphic:FlxSprite; //static one was missing due to this oops lmao

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var indicatorsLol:FlxSprite;
	var bgStatic:FlxSprite;
	var bgOverlay:FlxSprite;
	var staticFront:FlxSprite;

	var leTween:FlxTween = null;

	var movedBack:Bool = true; //needed for the victim tween.

	var camGame:FlxCamera;
	var camHUD:FlxCamera;

	var loadedWeeks:Array<WeekData> = [];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		camGame = initPsychCamera();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		if(!ClientPrefs.data.lowQuality)
		{
			victimGraphic = new FlxSprite().loadGraphic(Paths.image('menus/storyMode/selectyourvictim'));
			victimGraphic.cameras = [camHUD];
			victimGraphic.alpha = 0;
			victimShader = new FlxGlitchEffect(3, 10, 0.1, HORIZONTAL);
			victimText = new FlxEffectSprite (victimGraphic, [victimShader]);
			victimText.cameras = [camHUD];

			FlxTween.tween(victimGraphic, {alpha: 1}, 1, {
				ease: FlxEase.smoothStepOut,
				startDelay: 0.5,
			});
	
			FlxTween.tween(victimText, {alpha: 1}, 1, {
				ease: FlxEase.smoothStepOut,
				startDelay: 0.5,
			});
	
			FlxTween.tween(victimText, {alpha: 0}, 1, {
				ease: FlxEase.smoothStepOut,
				startDelay: 3,
			});
	
			FlxTween.tween(victimGraphic, {alpha: 0}, 1, {
				ease: FlxEase.smoothStepOut,
				startDelay: 3,
			});
		}
		else 
		{
			victimGraphic = new FlxSprite().loadGraphic(Paths.image('menus/storyMode/selectyourvictim'));
			victimGraphic.cameras = [camHUD];
			victimGraphic.alpha = 0;

			FlxTween.tween(victimGraphic, {alpha: 1}, 1, {
				ease: FlxEase.smoothStepOut,
				startDelay: 0.5,
			});
	
			FlxTween.tween(victimGraphic, {alpha: 0}, 1, {
				ease: FlxEase.smoothStepOut,
				startDelay: 3,
			});
		}

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.cameras = [camHUD];
		add(black);

		FlxTween.tween(black, {alpha: 0}, 1, {
			ease: FlxEase.smoothStepOut,
			startDelay: 3,
			onComplete: function (tween:FlxTween)
			{
				movedBack = false;
				if(!ClientPrefs.data.lowQuality) { 
					victimShader.active = false; 
				}
			}
		});

		var uiStory = Paths.getSparrowAtlas('menus/storyMode/storyArrows'); //the ui frames.

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode", "Selecting a Victim...");
		#end

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
				var weekThing:MenuItem = new MenuItem(10, 100, WeekData.weeksList[i]);
				weekThing.y += ((weekThing.height + 20) * num);
				weekThing.targetY = num;
				grpWeekText.add(weekThing);

				// Needs an offset thingie
				if (isLocked)
				{
					var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
					lock.antialiasing = ClientPrefs.data.antialiasing;
					lock.frames = uiStory;
					lock.animation.addByPrefix('lock', 'lock');
					lock.animation.play('lock');
					lock.ID = i;
					grpLocks.add(lock);
				}
				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(425, 465);
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
		leftArrow.frames = uiStory;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		Difficulty.resetList();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = Difficulty.getDefault();
		}
		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));
		
		sprDifficulty = new FlxSprite(leftArrow.x + 95, 465 - 35);
		sprDifficulty.antialiasing = ClientPrefs.data.antialiasing;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 340, 465);
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		rightArrow.frames = uiStory;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		bgStatic = new FlxSprite(0, 56); //static
		bgStatic.antialiasing = ClientPrefs.data.antialiasing;	
		if(!ClientPrefs.data.lowQuality)
		{
			bgStatic.frames = Paths.getSparrowAtlas('menus/storyMode/menubackgrounds/menu_static');
			bgStatic.animation.addByPrefix('static', 'static0');
			bgStatic.animation.play('static');
		}
		else
		{
			bgStatic.frames = Paths.getSparrowAtlas('menus/storyMode/menubackgrounds/menu_static');
			bgStatic.animation.addByPrefix('static', 'static0000');	
		}
		add(bgStatic);

		bgSprite = new FlxSprite(0, 56); //real bg
		bgSprite.antialiasing = ClientPrefs.data.antialiasing;
		add(bgSprite);

		staticFront = new FlxSprite(0, 56); //static
		staticFront.antialiasing = ClientPrefs.data.antialiasing;
		if(!ClientPrefs.data.lowQuality)
		{
			staticFront.frames = Paths.getSparrowAtlas('menus/storyMode/menubackgrounds/menu_static');
			staticFront.animation.addByPrefix('static', 'static0');
			staticFront.animation.play('static');
		}
		else
		{
			staticFront.frames = Paths.getSparrowAtlas('menus/storyMode/menubackgrounds/menu_static');
			staticFront.animation.addByPrefix('static', 'static0000');	
		}
		add(staticFront);

		bgOverlay = new FlxSprite(0, 56);
		bgOverlay.antialiasing = ClientPrefs.data.antialiasing;
		bgOverlay.frames = Paths.getSparrowAtlas('menus/storyMode/menubackgrounds/storyOverlay');
		bgOverlay.animation.addByPrefix('darkness', 'overlay', 24, true);
		bgOverlay.animation.play('darkness');
		add(bgOverlay);

		indicatorsLol = new FlxSprite(FlxG.width * 0.7, 480);
		indicatorsLol.antialiasing = ClientPrefs.data.antialiasing;
		indicatorsLol.frames =  Paths.getSparrowAtlas('menus/storyMode/indicators');
		indicatorsLol.animation.addByPrefix('playable', 'playable0', 24, true);
		indicatorsLol.animation.addByPrefix('wip', "wip0", 24, true);
		indicatorsLol.animation.play('playable');
		add(indicatorsLol);

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);
		add(scoreText);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;
		add(txtWeekTitle);

		if (!ClientPrefs.data.lowQuality) {
			add(victimText); //if the low quality is off, we add the glitch version of the text
		} else {
			add(victimGraphic); //else we just add the static one!!
		}

		changeWeek();
		changeDifficulty();

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "WEEK SCORE:" + lerpScore;

		if (!movedBack && !selectedWeek)
		{
			if (controls.UI_UP_P)
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.UI_DOWN_P)
			{
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeWeek(-FlxG.mouse.wheel);
				changeDifficulty();
			}

			if (controls.UI_RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.UI_LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

			if (controls.UI_RIGHT_P)
				changeDifficulty(1);
			else if (controls.UI_LEFT_P)
				changeDifficulty(-1);
			else if (controls.UI_UP_P || controls.UI_DOWN_P)
				changeDifficulty();

			if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				openSubState(new substates.GameplayChangersSubstate());
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new substates.ResetScoreSubState('', curDifficulty, '', curWeek));
			}
			else if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}
		super.update(elapsed);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
			lock.visible = (lock.y > FlxG.height / 2);
		});
	}

	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}
			
			// Nevermind that's stupid lmao
			try
			{
				PlayState.storyPlaylist = songArray;
				PlayState.isStoryMode = true;
				selectedWeek = true;

				var diffic = Difficulty.getFilePath(curDifficulty);
				if (diffic == null) diffic = '';

				PlayState.storyDifficulty = curDifficulty;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
			}
			catch(e:Dynamic)
			{
				trace('ERROR! $e');
				return;
			}

			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing(); //oopsies

				stopspamming = true;
			}
			
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});

			#if MODS_ALLOWED
			DiscordClient.loadModRPC();
			#end
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = Difficulty.getString(curDifficulty);
		var newImage:FlxGraphic = Paths.image('menus/storyMode/menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = leftArrow.x + 60;
			sprDifficulty.x += (308 - sprDifficulty.width) / 3;
			sprDifficulty.alpha = 0;
			sprDifficulty.y = leftArrow.y - 15;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		if (curWeek < 4) indicatorsLol.animation.play('playable', true);
		else if (curWeek > 4) indicatorsLol.animation.play('wip', true);
		if (curWeek == 4) indicatorsLol.animation.play('playable', true); //bug fix

		staticFront.alpha = 1;
		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			leTween = FlxTween.tween(staticFront, {alpha: 0}, 2, {ease: FlxEase.quadInOut});
		});

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = leWeek.storyName;
		txtWeekTitle.text = leName.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);
		
		var bullShit:Int = 0;

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && unlocked)
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}
		bgSprite.visible = true;
		
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			bgSprite.loadGraphic(Paths.image('menus/storyMode/menubackgrounds/menu_' + assetName));
		}
		PlayState.storyWeek = curWeek;

		Difficulty.loadFromWeek();
		difficultySelectors.visible = unlocked;

		if(Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		var newPos:Int = Difficulty.list.indexOf(lastDifficultyName);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		updateText();
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}
		
		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	function precacheMusic(sound:String, ?library:String = null):Void //moved it cuz is only used here lol
	{
		Paths.music(sound, library);
	}
}