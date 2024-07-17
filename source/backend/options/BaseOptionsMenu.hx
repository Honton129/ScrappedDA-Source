package backend.options;

import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;

class BaseOptionsMenu extends MusicBeatSubstate
{
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	//glitch effect stuff
	public static var glitchEffect:FlxGlitchEffect;
	public static var effectBF:FlxEffectSprite;

	private var grpOptions:FlxTypedGroup<FlxText>;

	private var descText:FlxText;
	var optionText:FlxText;

	public var rpcTitle:String;
	public var rpcDesc:String;

	public function new()
	{
		super();
		
		#if DISCORD_ALLOWED
		DiscordClient.changePresence('In the ' + rpcTitle + ' Category', 'Adjusting ' + rpcDesc);
		#end
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/optionsMenu/optionsBack'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		if(!ClientPrefs.data.lowQuality)
		{
			var glitchBF:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/optionsMenu/optionsGlitch'));
			glitchBF.antialiasing = false;
			glitchEffect = new FlxGlitchEffect(5, 10, 0.1, FlxGlitchDirection.HORIZONTAL);
			glitchEffect.active = true;
			effectBF = new FlxEffectSprite (glitchBF, [glitchEffect]);
			add(glitchBF);
			add(effectBF);
		}
		else
		{
			var glitchBF:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/optionsMenu/optionsGlitch'));
			glitchBF.antialiasing = false;
			add(glitchBF);
		}

		// avoids lagspikes while scrolling through menus!
		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...optionsArray.length)
		{
			var offset:Float = 95 - curSelected * 80;
			optionText = new FlxText(100, (i * 50) + offset, optionsArray[i].name + ": " + optionsArray[i].getValue(), 32, true);
			optionText.setFormat(Paths.font("pixel.otf"), 35,0xFF16FF00, FlxTextAlign.LEFT);
			optionText.borderSize = 3;
			optionText.borderQuality = 1;
			optionText.scrollFactor.set();
			optionText.ID = i;
			grpOptions.add(optionText);

			updateTextFrom(optionsArray[i]);
		}
		
		var bgFront:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/optionsMenu/optionsFront'));
		bgFront.antialiasing = ClientPrefs.data.antialiasing;
		add(bgFront);

		descText = new FlxText(50, 900, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		changeSelection();
	}

	public function addOption(option:Option) {
		if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
		optionsArray.push(option);
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var holdValue:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK) {
            if(!ClientPrefs.data.lowQuality) options.OptionsState.glitchShader.active = true;

			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(nextAccept <= 0)
		{
			var isBool = true;
			if(curOption.type != 'bool')
			{
				isBool = false;
			}

			if(isBool)
			{
				if(controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));

					//the same but a bit longer?, idk i will check it out
					if(grpOptions.members[curSelected] == grpOptions.members[curSelected]) 
						grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + ((curOption.getValue() == true)? false : true);
					
					curOption.setValue((curOption.getValue() == true) ? false : true);
					curOption.change();
				}
			} else {
				if(controls.UI_LEFT || controls.UI_RIGHT) {
					var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
					if(holdTime > 0.5 || pressed) {
						if(pressed) {
							var add:Dynamic = null;
							if(curOption.type != 'string') {
								add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
							}

							switch(curOption.type)
							{
								case 'int' | 'float' | 'percent':
									holdValue = curOption.getValue() + add;
									if(holdValue < curOption.minValue) holdValue = curOption.minValue;
									else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

									switch(curOption.type)
									{
										case 'int':
											holdValue = Math.round(holdValue);
											curOption.setValue(holdValue);

											//the same but a bit longer?, idk i will check it out
											if(grpOptions.members[curSelected] == grpOptions.members[curSelected])
												grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + holdValue;									
											
										case 'float' | 'percent':
											holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
											curOption.setValue(holdValue);

											//the same but a bit longer?, idk i will check it out
											if(grpOptions.members[curSelected] == grpOptions.members[curSelected])
												grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + holdValue;
									}

								case 'string':
									var num:Int = curOption.curOption; //lol
									if(controls.UI_LEFT_P) --num;
									else num++;

									if(num < 0) {
										num = curOption.options.length - 1;
									} else if(num >= curOption.options.length) {
										num = 0;
									}
			
									//the same but a bit longer?, idk i will check it out
									if(grpOptions.members[curSelected] == grpOptions.members[curSelected])
										grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + (curOption.options[num]);
									else if(grpOptions.members[curSelected] != grpOptions.members[curSelected])
										grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + (curOption.options[num]);

									curOption.curOption = num;
									curOption.setValue(curOption.options[num]); //lol
							}
							updateTextFrom(curOption);
							curOption.change();
							FlxG.sound.play(Paths.sound('scrollMenu'));
						} else if(curOption.type != 'string') {
							holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
							if(holdValue < curOption.minValue) holdValue = curOption.minValue;
							else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

							switch(curOption.type)
							{
								case 'int':
									curOption.setValue(Math.round(holdValue));
			
									//the same but a bit longer?, idk i will check it out
									if(grpOptions.members[curSelected] == grpOptions.members[curSelected])
										grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + (Math.round(holdValue));
								
								case 'float' | 'percent':
									curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
			
									//the same but a bit longer?, idk i will check it out
									if(grpOptions.members[curSelected] == grpOptions.members[curSelected])
										grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + (FlxMath.roundDecimal(holdValue, curOption.decimals));
							}
							updateTextFrom(curOption);
							curOption.change();
						}
					}
					if(curOption.type != 'string') {
						holdTime += elapsed;
					}
				} else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					clearHold();
				}
			}

			if(controls.RESET)
			{
				for (i in 0...optionsArray.length)
				{
					var leOption:Option = optionsArray[curSelected];
					leOption.setValue(leOption.defaultValue);

					if(grpOptions.members[curSelected] == grpOptions.members[curSelected])
						grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + (leOption.defaultValue);

					if(leOption.type != 'bool')
					{
						if(leOption.type == 'string') leOption.curOption = leOption.options.indexOf(leOption.getValue());

						if(grpOptions.members[curSelected] == grpOptions.members[curSelected])
							grpOptions.members[curSelected].text = optionsArray[curSelected].name + ": " + (leOption.getValue());

						updateTextFrom(leOption);
					}
					leOption.change();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function updateTextFrom(option:Option) {
		var text:String = option.displayFormat;
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;
		var def:Dynamic = option.defaultValue;
		option.text = text.replace('%v', val).replace('%d', def);
	}

	function clearHold()
	{
		if(holdTime > 0.5) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		holdTime = 0;
	}
	
	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsArray.length - 1;
		if (curSelected >= optionsArray.length)
			curSelected = 0;

		descText.text = optionsArray[curSelected].description;
		descText.screenCenter(Y);
		descText.y += 320; //testing smth.

		// I wanna die!!!
		for (i in grpOptions.members) {
			if (grpOptions.members[curSelected].text != i.text)
				i.alpha = 0.35;
			else
				i.alpha = 1;
		}
		curOption = optionsArray[curSelected]; //shorter lol
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}