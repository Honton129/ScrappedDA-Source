package states;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var bgFront:FlxSprite;
	var descText:FlxText;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Credits Menu", "Watching the credits!!!");
		#end

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		persistentUpdate = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menus/creditsMenu/creditsBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		bgFront = new FlxSprite(3000, 0).loadGraphic(Paths.image('menus/creditsMenu/creditsFG'));
		bgFront.antialiasing = ClientPrefs.data.antialiasing;
		bgFront.screenCenter(Y);
		add(bgFront);

		FlxTween.tween(bgFront, {x: 0}, 1, {
			ease: FlxEase.sineInOut,
			startDelay: 0,
		});
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled) pushModCreditsToList(mod); //man i am impressed on how that long code become just one line, my respects Shadow Mario -Honton129
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			["The Corrupted B-Sides Team"],
     	 	['Honton129',		    'honton',	        "-Mod Director\n-Coder\n-Lead Artist\n-Charter",                                                       'https://twitter.com/honton129'],
    		['AllyTS',		        'ts',	            "-Original Idea!\n-Musician\n-Chiller B-SIDE Remix!",	                                               'https://twitter.com/NewTioSans'],
			['Poga',			    'poga',		        "-Artist\n-Pico Redesign Helper\n-Musician\n-Game Over Theme\n-Main Menu Theme Remix!",                'https://www.youtube.com/@Poga_2000'],
			['Nox',			        'nox',		        "-Musician\n-Main Menu Remix (Ambient)",                                                               'https://www.youtube.com/@nox91422'],
			['yupod',			    'yupoto',		    "-Artist\n-Pico Redesign Creator!\n-Background Sprites!\n", 	                                       'https://www.youtube.com/@yupoto'],
			['Dasklp',			    'dasklp',		    "-Artist\n-Pico Redesign Helper!\n-Mom Week Background!",                                              'https://www.youtube.com/@dasklp5029'],
			['arbolman',			'arbol',		    "-Artist\n-Mom Design Concept", 	                                                                   'https://www.youtube.com/@soul2709'],
			['Mountainboy',			'mountain',	        "-Icon Artist\n-Pico Week Backgrouds",	                                                               'https://twitter.com/Davedcho19'],
			['veku',	            'veku',		        "-Made the Corrupted Arcade Assets\n(TYSM!)",	                                                       'https://www.youtube.com/@im-veku'],
			['Vojbra',	            'voj',		        "-Charter\n-Mom Week\n-Senpai Week",                                                                   'https://twitter.com/voj_bra'],	
			//['LoganMcOof',			'logan',		    "-Musician\n-Lament B-SIDE Remix!\n-Dusk B-SIDE Remix!",                                               'https://www.youtube.com/@LoganMcOof'],
			['WeegeeDude',			'weegee',		    "-Musician\n-Pico Week B-SIDE Remixes\n-Senpai Glitch B-SIDE Remix\n-Roots B-SIDE Remix!",             'https://www.youtube.com/@weegeedudebutitsfnf.1468'],
			['Rhodes_W',			'rhodes',		    "-Musician\n-M.I.L.K B-SIDE Remix\n-Schizophrenzy B-SIDE Remix!\n-Treacherous Thorns B-SIDE Remix!",   'https://www.youtube.com/@rhodes_w1338'],
			['Benkamyn',	        'benka',		    "-Musician\n-Broken Melancholy Song!\n-Dead Pixel B-SIDE Remix!",                                      'https://www.youtube.com/@Ben-Kamyn'],
			//['FilRclter',	        'fil',		        "-Artist\n-Daddy Dearest Design Rework!",                                                              ''],
    	  	[''],
			["Helpers And Colaborators"],
			['Femmie',	            'femmie',		    "-The Whole Pixel Week B-SIDE Designs\n(TYSM FOR THE HELP FEMMIE!)\n(GO SUPPORT HER NOW!)",	           'https://twitter.com/Femnt49'],
			['MarioKidPastaWay',	'mariokid',		    "-First Demo Pico Redesign Artist\n-(Thx for let me use it\nfor a time!)",	                           'https://www.youtube.com/@mariokidpastaway1109'],
			['SaGa!',               'saga',		        "-Chiller B-SIDE V3 Musician!\n(TYSM FOR LET ME USE IT!)",                                             'https://twitter.com/sagadacasinhaa'],
			['garlic',	            'garlic',		    "-Matricidal B-SIDE Remix!",	                                                                       'https://www.youtube.com/@garlic1305'],
			['Tikaz',	            'tikaz',		    "-Helped On Classic Mom Sprites!\n(TYSM!)",	                                                           'https://www.youtube.com/@whoistikaz'],
			['akbar',               'akbar',		    "-Helped On Classic Pico Sprites!",                                                                    'https://www.youtube.com/@akbarondiscord6063'],
			['ChatGPT',	            'gpt',		        "-Literally fixed\nthe options menu lmfao",	                                                           'https://openai.com/blog/chatgpt'],
			['TCB: Classic Edition','tcb',		        "-Base code for the menus\n-Title Screen Art!",	                                                                       'https://twitter.com/TheCorruptedB'],
			["Box Funkin'",         'box',		        "-Base code for the window dark mode!\n-from Wednesday Infidelity!",	                               'https://twitter.com/BoxFunkin'],
			['Luis F3697',		    'luis',	            "-Redux BF .FLA\n-Redux Spooky's .FLA",                                                                'https://www.youtube.com/@Luis-F3697'],
			['UltraCorruptBF',      'ultra',            "-B-SIDE Menu CBF Artist!",                                                                            'https://www.youtube.com/@ultracorruptbf '],
			['GT4_Fire',            'gt4',		        "-Weeks Names\n-Video Titles\n-Senpai Week Dialogues\n(TYSM!)",                                        'https://twitter.com/TheRealGT4_Fire'],
			['Ciovo06',			    'ciovo',		    "-Game Over Positions Fix!\n(TYSM!)",                                                                  'https://www.youtube.com/@cxv8427'],
     		['dayla.',			    'dayla',		    "-Philly B-SIDE Remix!",                                                                       'https://www.youtube.com/c/daylawithasideofmilk'],
			['VargyBoy',			'vargy',		    "-Pixelate Shader Lua!",                                                                               'https://www.youtube.com/@vargyboy932'],
			['Whisper',             'whisper',		    "-Pico B-SIDE Remix Charter",                                                                          'https://twitter.com/flutterlicious_'],
			[''],
			[''],
			["B-Side Redux Crew"],
    		['Rozebud',		        'rozebud',	        "-Music, Charting And Art\nOf B-SIDE Redux\n-The Chart Editor dudes",		                           'https://twitter.com/helpme_thebigt'],
    		['JADS',		        'jads',          	"-Music And Charting\nOf B-SIDE Redux",					                                               'https://twitter.com/Aw3somejds'],
		    ['Cval',		        'cval',	          	"-Additional Art And Charting\nOf B-SIDE Redux",		                                               'https://twitter.com/cval_brown'],
			['elikapika',           'elika',	        "-Additional Art\nOf B-SIDE Redux",		                                                               'https://twitter.com/elikapika'],
			['fluffyhairs',	        'fluffyhairs',		"-Music\nOf B-SIDE Redux",		                                                                       'https://twitter.com/fluffyhairslol'],
			[''],
			[''],
		    ["Corruption Mod Team"],
		    ['PhantomFear',		    'phantomfear',	    "-Creator/Director\n-Lead Artist\n-Coder\n-Story",			                                           'https://twitter.com/PhantomFearOP'],
		    ['PincerProd',	    	'pincerprod',	    "-Roots +\nTreacherous Thorns\nBackground Art\n-Threacherous Throns\nChart",			               'https://twitter.com/PincerProd'],
		    ['RenRenNumberTen',	    'ren',			    "-Musician\n-Spookeez-Remix",				                                                           'https://www.youtube.com/@RenRenNumberTen'],
		    ['DatDavi',			    'datdavi',			"-Musician\n-Senpai Remix\n-Treacherous Thorns",                                                       'https://twitter.com/dat_davi'],
		    ['SimplyCrispy',		'simplycrispy',		"-Musician\n-Matricidal\n-MILK\n-Schizophrenzy",				                                       'https://twitter.com/BreakfastsBest'],
		    ['fluffyhairs',		    'fluffyhairs',		"-Musician\n-Sanguine South\n-Chiller\n-Story Menu Music",		                                       'https://twitter.com/fluffyhairslol'],
	    	['SasterSuboru',		'saster',		    "-Musician\n-Tormentor\n-Neuroses\n-Discharge\n-Estranged Instrumental",                               'https://twitter.com/sub0ru'],
	    	[''],
			[''],
			['Psych Engine Team'],
			['Shadow Mario',		'shadowmario',		'-P.E Main Programmer',								                                                   'https://twitter.com/Shadow_Mario_'],
			['Riveren',				'riveren',			'-P.E Main Artist\n-P.E Main Animator',					                                               'https://twitter.com/riverennn'],
			[''],
			['Former Engine Members'],
			['shubs',				'shubs',			'-P.E Additional Ex-Programmer',					             	                                   'https://twitter.com/yoshubs'],
			['bb-panzu',			'bb',				'-P.E Ex-Programmer',								                                   	               'https://twitter.com/bbsub3'],
			[''],
			['Engine Contributors'], 
			['iFlicky',				'flicky',			'-Composer of Psync and Tea Time\n-Made the Dialogue Sounds',		                                   'https://twitter.com/flicky_i'],
			['SqirraRNG',			'sqirra',			'-Crash Handler\n-Base code for Chart Editor\'s Waveform',                           	               'https://twitter.com/gedehari'],
			['EliteMasterEric',		'mastereric',		'-Runtime Shaders support',										                                       'https://twitter.com/EliteMasterEric'],
			['PolybiusProxy',		'proxy',			'-.MP4 Video Loader Library\n(hxCodec)',					                                           'https://twitter.com/polybiusproxy'],
			['Tahir',				'tahir',			'-Implementing & mantaining SScript on Psych',                                                         'https://github.com/TahirKarabekiroglu'],
			['KadeDev',				'kade',				'-Fixed some cool stuff on Chart Editor\nand Other PRs',		                                       'https://twitter.com/kade0912'],
			['CrowPlexus',          'crow',             '-Input System v3 \nand Other PRs',                                                                    'https://twitter.com/crowplexus'],
			['Keoiki',				'keoiki',			'-Note Splash Animations\n-Latin Alphabet',										                       'https://twitter.com/Keoiki_'],
			['superpowers04',		'superpowers04',	'-LUA JIT Fork',													                                   'https://twitter.com/superpowers04'],
			[''], 
			["Funkin' Crew"],
			['ninjamuffin99',		'ninjamuffin99',	"-FNF' Programmer",						                                               	               'https://twitter.com/ninja_muffin99'],
			['PhantomArcade',		'phantomarcade',	"-FNF' Animator",						                                               	               'https://twitter.com/PhantomArcade3K'],
			['evilsk8r',			'evilsk8r',			"-FNF' Artist",							                                               	               'https://twitter.com/evilsk8r'],
			['kawaisprite',			'kawaisprite',		"-FNF' Composer",							                                           	               'https://twitter.com/kawaisprite']
		];

		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(30, 300, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Mods.currentModDirectory = creditsStuff[i][5];
				}

				var str:String = 'menus/creditsMenu/icons/missing_icon';
				var fileName = 'menus/creditsMenu/icons/' + creditsStuff[i][1];
				if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;
				else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE)) str = fileName + '-pixel';

				var icon:AttachedSprite = new AttachedSprite(str);
				if(str.endsWith('-pixel')) icon.antialiasing = false;
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Mods.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			else optionText.alignment = LEFT;
		}

		descText = new FlxText(350, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		add(descText);

		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}