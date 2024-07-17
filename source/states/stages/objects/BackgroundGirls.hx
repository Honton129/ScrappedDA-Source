package states.stages.objects;

class BackgroundGirls extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		antialiasing = false;
		frames = Paths.getSparrowAtlas('weeb/bgFreaks');
        swapDanceType(false, false);

		setGraphicSize(Std.int(width * PlayState.daPixelZoom));
		updateHitbox();
		animation.play('danceLeft');
	}

	var danceDir:Bool = false;
	public function swapDanceType(isGlitch:Bool = false, isGhoul:Bool = false):Void
	{
		if(!isGlitch && !isGhoul) { //Normal
			animation.addByIndices('danceLeft', 'BG girls group', CoolUtil.numberArray(14), "", 24, false);
			animation.addByIndices('danceRight', 'BG girls group', CoolUtil.numberArray(30, 15), "", 24, false);
		} else if(isGlitch && !isGhoul) { //Gliched
			animation.addByIndices('danceLeft', 'BG fangirls glitch', CoolUtil.numberArray(14), "", 24, false);
			animation.addByIndices('danceRight', 'BG fangirls glitch', CoolUtil.numberArray(30, 15), "", 24, false);
		} else if(!isGlitch && isGhoul) { //Ghouls
			animation.addByPrefix('danceLeft', 'BG fangirls ghoul', 24, true);
			animation.addByPrefix('danceRight', 'BG fangirls ghoul', 24, true);
		}
		dance();
	}

	public function dance():Void
	{
		danceDir = !danceDir;

		if (danceDir)
			animation.play('danceRight', true);
		else
			animation.play('danceLeft', true);
	}
}
