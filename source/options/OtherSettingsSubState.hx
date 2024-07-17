package options;

class OtherSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		rpcDesc = 'Other Settings';
		rpcTitle = 'Misc. Game Settings'; //deezcord shit

		#if DISCORD_ALLOWED
		DiscordClient.changePresence('In the ' + rpcTitle + ' Category', 'Adjusting ' + rpcDesc);
		#end

		var option:Option = new Option('Note Splash Opacity',
			'How much transparent should the Note Splashes be.',
			'splashAlpha',
			'percent');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		#if DISCORD_ALLOWED
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord",
			'discordRPC',
			'bool');
		addOption(option);
		#end

		var option:Option = new Option('Auto Pause',
			"If checked, the game automatically pauses if the screen isn't on focus.",
			'autoPause',
			'bool');
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Pause Screen Song',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			['None', 'Main Theme', 'Tea Time', 'Breakfast']);
		addOption(option);
		option.onChange = onChangePauseMusic;

		var option:Option = new Option('Intro Warnings',
			"If unchecked, the warnings will no longer appear when you start the game",
			'introWarnings',
			'bool');
		addOption(option);

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	function onChangeAutoPause()
	{
		FlxG.autoPause = ClientPrefs.data.autoPause;
	}

	override function destroy()
	{
		if(changedMusic && !options.OptionsState.onPlayState)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);
		else if(changedMusic && options.OptionsState.onPlayState)
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		super.destroy();
	}
}