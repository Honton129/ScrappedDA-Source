package states.stages;

class Highway extends BaseStage
{
	var city:BGSprite;
	var thePole:BGSprite;
	var street:BGSprite;
	var skyBG:BGSprite;
	var sign:BGSprite;
	var limo:BGSprite;

	var black:BGSprite;

	override function create()
	{
		skyBG = new BGSprite('street/sky', -300, -500, 0.1, 0.1);
		skyBG.setGraphicSize(Std.int(skyBG.width * 1.2));
		skyBG.updateHitbox();
		add(skyBG);

		city = new BGSprite('street/city', -500, -100, 0.4, 0.4);
		add(city);

		sign = new BGSprite('street/sign', -100, -100, 0.6, 0.6);
		add(sign);

		thePole = new BGSprite('street/pole', 0, -50, 0.8, 0.8);
		add(thePole);

		street = new BGSprite('street/street', -450, 800, 0.95, 0.95);
		street.setGraphicSize(Std.int(street.width * 1.2));
		street.updateHitbox();
		add(street);

		limo = new BGSprite('street/limoStand', -120, -285, 1, 1);
		add(limo);

		black = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
		black.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.BLACK);
		black.cameras = [camOverlay];
		black.alpha = 0.00001;
		add(black);
	}
    override function createPost() {
		if (PlayState.SONG.song.toLowerCase() == 'matricidal') {
			black.alpha = 1;
			camHUD.alpha = 0.0001;
		}
	}

	override function beatHit() {
		if (PlayState.SONG.song.toLowerCase() == 'matricidal') {
			if (curBeat == 4) {
				FlxTween.tween(black, {alpha: 0.25}, 6.5, {ease: FlxEase.quadOut});
			}

			if (curBeat == 32) {
				FlxTween.tween(camHUD, {alpha: 1}, 1.5, {ease: FlxEase.quadOut});
			}

			if (curBeat == 64) {
				black.alpha = 0;
			}

			if (curBeat == 96) {
				FlxTween.tween(black, {alpha: 0.35}, 2, {ease: FlxEase.quadOut});
			}

			if (curBeat == 180) {
				FlxTween.tween(black, {alpha: 0}, 2, {ease: FlxEase.quadOut});
			}

			if (curBeat == 248) {
				FlxTween.tween(black, {alpha: 0.35}, 1, {ease: FlxEase.quadOut});
			}
		}
	}
}