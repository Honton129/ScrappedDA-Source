package states.stages;

class Philly extends BaseStage
{
	var phillySky:BGSprite;
	var phillyCity:BGSprite;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var yupodElao:BGSprite;
	var pogaCorrupted:BGSprite;
	var skidLmao:BGSprite;
	var picoText:BGSprite;

	var phillyLightsColors:Array<FlxColor> = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
	var curLight:Int = -1;

	override function create()
	{
		phillySky = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
		add(phillySky);

		phillyCity = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
		phillyCity.setGraphicSize(Std.int(phillyCity.width * 0.85));
		phillyCity.updateHitbox();
		add(phillyCity);

		if(!ClientPrefs.data.lowQuality)
		{
			phillyWindow = new BGSprite('philly/window', phillyCity.x, phillyCity.y, 0.3, 0.3);
			phillyWindow.setGraphicSize(Std.int(phillyWindow.width * 0.85));
			phillyWindow.alpha = 0.00001;
			phillyWindow.updateHitbox();
			add(phillyWindow);
		}

		phillyStreet = new BGSprite('philly/street', -40, 50);
		add(phillyStreet);

		yupodElao = new BGSprite('philly/yupodCongelao', 1140, 300, 0.95, 0.95, ['webadas']);
		yupodElao.setGraphicSize(Std.int(yupodElao.width * 0.8));
		add(yupodElao);

		skidLmao = new BGSprite('philly/skid', 195, 375, 0.95, 0.95, ['skid idle']);
		skidLmao.setGraphicSize(Std.int(skidLmao.width * 1.15));
		skidLmao.flipX = true;
		add(skidLmao);

		pogaCorrupted = new BGSprite('philly/corrupted_poga', 230, 775, 1.3, 1.3, ['idle']);
		pogaCorrupted.setGraphicSize(Std.int(pogaCorrupted.width * 1.5));

		picoText = new BGSprite('philly/cuando-pico-quiere', 0, 0);
		picoText.cameras = [camOverlay];
		picoText.alpha = 0.0001;
		add(picoText);
	}
	override function createPost()
	{
		add(pogaCorrupted);
	}

	override function update(elapsed:Float)
	{
		phillyWindow.alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;
	}

	override function countdownTick(count:Countdown, num:Int) everyoneDance();
	override function beatHit()
	{
		everyoneDance();

		if (PlayState.SONG.song.toLowerCase() == 'fight-or-flight')
		{
			if (curBeat == 59)
			{
				FlxTween.tween(picoText, {alpha: 1}, 1.2);
			}
	
			if (curBeat == 63)
			{
				FlxTween.tween(picoText, {alpha: 0}, 0.35);
			}
		}

		if (curBeat % 4 == 0)
		{
			curLight = FlxG.random.int(0, phillyLightsColors.length - 1, [curLight]);
			phillyWindow.color = phillyLightsColors[curLight];
			phillyWindow.alpha = 1;
		}
	}

	function everyoneDance()
	{
		if(!ClientPrefs.data.lowQuality && curBeat % game.gfSpeed == 0)
		{
			skidLmao.dance(true);
			yupodElao.dance(true);
			pogaCorrupted.dance(true);
		}
	}
}