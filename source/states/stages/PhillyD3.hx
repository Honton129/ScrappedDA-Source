package states.stages;

class PhillyD3 extends BaseStage
{
	var phillySky:BGSprite;
	var phillyCity:BGSprite;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var yupodElao:BGSprite;
	var pogaCorrupted:BGSprite;
	var mathxMiedoPng:BGSprite;
	var skidLmao:BGSprite;
	var overlay:BGSprite;
	var white:BGSprite;

	override function create()
	{
		phillySky = new BGSprite('philly3/sky', -100, 0, 0.1, 0.1);
		add(phillySky);

		phillyCity = new BGSprite('philly3/city', -10, 0, 0.3, 0.3);
		phillyCity.setGraphicSize(Std.int(phillyCity.width * 0.85));
		phillyCity.updateHitbox();
		add(phillyCity);

		phillyStreet = new BGSprite('philly3/street', -40, 50);
		add(phillyStreet);

		mathxMiedoPng = new BGSprite('philly3/el_mathx', 960, 340, 0.95, 0.95, ['mathx idle']);
		mathxMiedoPng.setGraphicSize(Std.int(mathxMiedoPng.width * 0.8));
		add(mathxMiedoPng);

		yupodElao = new BGSprite('philly3/yupodCongelao', 1140, 300, 0.95, 0.95, ['webadas']);
		yupodElao.setGraphicSize(Std.int(yupodElao.width * 0.8));
		add(yupodElao);

		skidLmao = new BGSprite('philly3/skid', 195, 375, 0.95, 0.95, ['skid idle']);
		skidLmao.setGraphicSize(Std.int(skidLmao.width * 1.15));
		skidLmao.flipX = true;
		add(skidLmao);

		pogaCorrupted = new BGSprite('philly3/corrupted_poga', 230, 775, 1.3, 1.3, ['idle']);
		pogaCorrupted.setGraphicSize(Std.int(pogaCorrupted.width * 1.5));

		white = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
		white.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
		white.cameras = [camOverlay];
		white.alpha = 0.00001;
		white.blend = ADD;

		overlay = new BGSprite('philly3/overlay');
		overlay.antialiasing = ClientPrefs.data.antialiasing;
		overlay.cameras = [camOverlay];
		add(overlay);
	}
	override function createPost()
	{
		add(pogaCorrupted);

		if (PlayState.SONG.song.toLowerCase() == 'fallen-soldier')
		{
			boyfriend.alpha = 0.00001;
			gf.alpha = 0.00001;
			dad.alpha = 0.00001;

			phillySky.alpha = 0.00001;
			phillyCity.alpha = 0.00001;
			phillyStreet.alpha = 0.00001;
			yupodElao.alpha = 0.00001;
			pogaCorrupted.alpha = 0.00001;
			mathxMiedoPng.alpha = 0.00001;
			skidLmao.alpha = 0.00001;
		}
	}

	override function countdownTick(count:Countdown, num:Int) everyoneDance();
	override function beatHit()
	{
		everyoneDance();

		if (PlayState.SONG.song.toLowerCase() == 'fallen-soldier')
		{
			if (curBeat == 16)
			{
				FlxTween.tween(dad, {alpha: 1}, 1);
			}
				
			if (curBeat == 32)
			{
				FlxTween.tween(boyfriend, {alpha: 1}, 1);
			}
	
			if (curBeat == 48)
			{
				FlxTween.tween(gf, {alpha: 1}, 1);
			}
	
			if (curBeat == 76)
			{
				FlxTween.tween(white, {alpha: 1}, 1.5);
			}	
				
			if (curBeat == 80)
			{
				FlxTween.tween(white, {alpha: 0}, 0.8);

				phillySky.alpha = 1;
				phillyCity.alpha = 1;
				phillyStreet.alpha = 1;
				yupodElao.alpha = 1;
				pogaCorrupted.alpha = 1;
				mathxMiedoPng.alpha = 1;
				skidLmao.alpha = 1;
			}

			if (curBeat == 192)
			{
				FlxTween.tween(pogaCorrupted, {alpha: 0}, 1); 
			}

			if (curBeat == 256)
			{
				FlxTween.tween(pogaCorrupted, {alpha: 1}, 1); 
			}
		}
	}

	function everyoneDance()
	{
		if(!ClientPrefs.data.lowQuality && curBeat % game.gfSpeed == 0)
		{
			skidLmao.dance(true);
			yupodElao.dance(true);
			mathxMiedoPng.dance(true);
			pogaCorrupted.dance(true);
		}
	}
}