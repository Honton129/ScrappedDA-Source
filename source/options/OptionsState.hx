package options;

import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;

class OptionsState extends MusicBeatState
{
	public static var options:Array<String> = ['Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', 'Others'];
	
	private var grpOptions:FlxTypedGroup<FlxText>;
	private static var curSelected:Int = 0;

	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;

	private var descText:FlxText;
	var optionText:FlxText;

	//glitch effect stuff
	public static var glitchShader:FlxGlitchEffect;
	public static var effectBF:FlxEffectSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
			case 'Others':
				openSubState(new options.OtherSettingsSubState());				
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In The Options Menu", 'Selecting a Category');
		#end

		FlxG.camera.fade(0xFF000000, 3.5, true);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/optionsMenu/optionsBack'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		if(!ClientPrefs.data.lowQuality)
		{
			var glitchBF:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/optionsMenu/optionsGlitch'));
			glitchBF.antialiasing = false;
			glitchShader = new FlxGlitchEffect(5, 10, 0.1, FlxGlitchDirection.HORIZONTAL);
			effectBF = new FlxEffectSprite (glitchBF, [glitchShader]);
			add(glitchBF);
			add(effectBF);
		}
		else
		{
			var glitchBF:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/optionsMenu/optionsGlitch'));
			glitchBF.antialiasing = false;
			add(glitchBF);
		}

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...options.length) //i love you chatgpt, thanks for fix the code lmao <3
		{
			var posY:Float = i * 50 + 200;
			optionText = new FlxText(100, posY, options[i], 32, true);
			optionText.setFormat(Paths.font("pixel.otf"), 35, 0xFF16FF00, FlxTextAlign.LEFT);
			optionText.borderSize = 3;
			optionText.borderQuality = 1;
			optionText.scrollFactor.set();
			grpOptions.add(optionText);
		}			

		var bgFront:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/optionsMenu/optionsFront'));
		bgFront.antialiasing = ClientPrefs.data.antialiasing;
		add(bgFront);

		descText = new FlxText(50, 800, 1180, "Please Select a Category.", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		descText.screenCenter(Y);
		descText.y += 270;
		add(descText);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			if(!ClientPrefs.data.lowQuality) glitchShader.active = false;

			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else MusicBeatState.switchState(new states.MainMenuState());
		}
		
		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]); 
			if(!ClientPrefs.data.lowQuality) {
				glitchShader.active = false; //lag fix i think
			}
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		// I wanna die!!!
		for (i in grpOptions.members) {
			if (grpOptions.members[curSelected].text != i.text)
				i.alpha = 0.35;
			else
				i.alpha = 1;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}