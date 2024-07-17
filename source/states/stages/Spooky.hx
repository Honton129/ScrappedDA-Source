package states.stages;

class Spooky extends BaseStage
{
	var spookySky:BGSprite;
	var spookyFence:BGSprite;
	var spookyFloor:BGSprite;
	var spookyHouse:BGSprite;

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
	}
}