package states;

import flixel.effects.FlxFlicker;

class MainMenuState extends MusicBeatState
{
	public static var engineVersion:String = '0.7.3c';
	public static var modVersion:String = '0.0.1-alpha';
	public static var funkinVersion:String = '0.2.8';

	var bsideVerTxt:String = "FNFBC: Darkness Ascension v" + modVersion;
	var psychVerTxt:String = "Psych Engine v" + engineVersion;
	var funkinVerTxt:String = "Friday Night Funkin' v" + funkinVersion;

	var curSelected:Int = 0;
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'donate',
		'options'
	];

	var menuItems:FlxTypedGroup<FlxSprite>;

	var bgStatic:FlxSprite;
	var overlay:FlxSprite;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		DiscordClient.changePresence("In the Main Menu", "Selecting a Mode");
		#end

		if(!FlxG.sound.music.playing) FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);

		persistentUpdate = persistentDraw = true;

		bgStatic = new FlxSprite();
		bgStatic.frames = Paths.getSparrowAtlas('menus/mainMenu/menuBG');
		bgStatic.antialiasing = ClientPrefs.data.antialiasing;
		bgStatic.animation.addByPrefix('idle', 'bg', 24, true);
		bgStatic.animation.play('idle');
		add(bgStatic);

		overlay = new FlxSprite().loadGraphic(Paths.image('menus/mainMenu/epicConsolador'));
		overlay.antialiasing = ClientPrefs.data.antialiasing;
		add(overlay);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

    	for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 100 + (i * 100));
			menuItem.frames = Paths.getSparrowAtlas('menus/mainMenu/items/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.scrollFactor.set();
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.ID = i;
			menuItems.add(menuItem);

			if(menuItem.ID == 4)
				menuItem.y += 10;
			
			menuItem.x -= 500;
			menuItem.alpha = 0;
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.90));

			FlxTween.tween(menuItem, {alpha: 1, x: menuItem.x + 525}, 0.7, {startDelay: 0.3 * i, ease: FlxEase.smoothStepOut});
		}

		var versionText:FlxText = new FlxText(12, FlxG.height - 64, 0, 
            		bsideVerTxt + 
			'\n'  + psychVerTxt + 
			'\n'  + funkinVerTxt, 12);
		versionText.setFormat("Drum N Bass 22", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionText);

		var controlsTip:FlxText = new FlxText(710, FlxG.height - 21, 0, "Press '1' for open the Mods Menu, Press '7' for the Debug Menu", 16);
		controlsTip.setFormat("Drum N Bass 22", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(controlsTip);

		changeItem();
		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
            {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
		    }

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://twitter.com/FNFCB_SidesDa');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];
								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new states.StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new states.freeplay.FreeplayState());
									case 'credits':
										MusicBeatState.switchState(new states.CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
										options.OptionsState.onPlayState = false;
										if (PlayState.SONG != null)
										{
											PlayState.SONG.arrowSkin = null;
											PlayState.SONG.splashSkin = null;
										}
								}
							});
						}
					});
				}
			}	
	    }

		#if desktop
		if (controls.justPressed('debug_1'))
		{
			selectedSomethin = true;
			MusicBeatState.switchState(new states.editors.MasterEditorMenu());
			FlxG.sound.play(Paths.sound('confirmMenu'));
		}
		#end

		#if (MODS_ALLOWED && desktop)
		if (FlxG.keys.justPressed.ONE)
		{
			selectedSomethin = true;
			MusicBeatState.switchState(new ModsMenuState());
			FlxG.sound.play(Paths.sound('confirmMenu'));
		}
		#end

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

    	menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}
		});
	}
}