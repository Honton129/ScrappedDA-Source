package states.stages;

class SpookyD2 extends BaseStage
{
	var spookySky:BGSprite;
	var spookyFence:BGSprite;
	var spookyFloor:BGSprite;
	var spookyHouse:BGSprite;

	var vergaChica:BGSprite;

	var textoCuliao:BGSprite;
	var overlayAmpofix:BGSprite;

	override function create()
	{
		spookySky = new BGSprite('sky69', -200, -200, 0.55, 0.55);
		add(spookySky);

		spookyFence = new BGSprite('cercaPeruana', -100, -100, 0.8, 0.8);
		add(spookyFence);

		spookyFloor = new BGSprite('suelo');
		add(spookyFloor);

		spookyHouse = new BGSprite('laCasaDelSemenYPorno', 0, 200, 0.95, 0.95);
		add(spookyHouse);

		vergaChica = new BGSprite('vargi', 1050, 650, 1, 1, ['idle']);
		vergaChica.scale.set(0.65, 0.65);
		add(vergaChica);

		textoCuliao = new BGSprite('textoJiji');
		textoCuliao.cameras = [camOverlay];
		textoCuliao.alpha = 0.00001;
		add(textoCuliao);

		overlayAmpofix = new BGSprite('webadaAmpofix');
		overlayAmpofix.cameras = [camOverlay];
		add(overlayAmpofix);
	}
	override function createPost()
	{
		if(PlayState.SONG.song.toLowerCase() == 'corrupt-south')
		{
			camHUD.alpha = 0.00001;
		}
	}

	override function countdownTick(count:Countdown, num:Int) everyoneDance();
	override function beatHit()
	{
		everyoneDance();

		if(PlayState.SONG.song.toLowerCase() == 'corrupt-south')
		{
			if (curBeat == 15)
			{
				FlxTween.tween(textoCuliao, {alpha: 1}, 1);
			}

			if (curBeat == 16)
			{
				FlxTween.tween(textoCuliao, {alpha: 0}, 0.5);
				camHUD.alpha = 1;
			}
		}
	}

	function everyoneDance()
	{
		if (!ClientPrefs.data.lowQuality && curBeat % game.gfSpeed == 0)
		{
			vergaChica.dance(true);
		}
	}
}