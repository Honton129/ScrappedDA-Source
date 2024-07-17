package states.stages;

class PhillyD2 extends BaseStage
{
	var phillySky:BGSprite;
	var phillyCity:BGSprite;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var yupodElao:BGSprite;
	var pogaCorrupted:BGSprite;
	var mathxMiedoPng:BGSprite;
	var skidLmao:BGSprite;

	override function create()
	{
		phillySky = new BGSprite('philly2/sky', -100, 0, 0.1, 0.1);
		add(phillySky);

		phillyCity = new BGSprite('philly2/city', -10, 0, 0.3, 0.3);
		phillyCity.setGraphicSize(Std.int(phillyCity.width * 0.85));
		phillyCity.updateHitbox();
		add(phillyCity);

		phillyStreet = new BGSprite('philly2/street', -40, 50);
		add(phillyStreet);

		mathxMiedoPng = new BGSprite('philly2/el_mathx', 960, 340, 0.95, 0.95, ['mathx idle']);
		mathxMiedoPng.setGraphicSize(Std.int(mathxMiedoPng.width * 0.8));
		add(mathxMiedoPng);

		yupodElao = new BGSprite('philly2/yupodCongelao', 1140, 300, 0.95, 0.95, ['webadas']);
		yupodElao.setGraphicSize(Std.int(yupodElao.width * 0.8));
		add(yupodElao);

		skidLmao = new BGSprite('philly2/skid', 195, 375, 0.95, 0.95, ['skid idle']);
		skidLmao.setGraphicSize(Std.int(skidLmao.width * 1.15));
		skidLmao.flipX = true;
		add(skidLmao);

		pogaCorrupted = new BGSprite('philly2/corrupted_poga', 230, 775, 1.3, 1.3, ['idle']);
		pogaCorrupted.setGraphicSize(Std.int(pogaCorrupted.width * 1.5));
	}
	override function createPost()
	{
		add(pogaCorrupted);
	}

	override function countdownTick(count:Countdown, num:Int) everyoneDance();
	override function beatHit()
	{
		everyoneDance();

		if (PlayState.SONG.song.toLowerCase() == 'showdown')
		{
			if (curBeat == 480)
			{
				camHUD.visible = false;
				camGame.visible = false;
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