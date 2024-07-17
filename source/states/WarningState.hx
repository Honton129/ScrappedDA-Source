package states;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;

class WarningState extends MusicBeatState 
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    var chains:FlxSprite;
    var warningsGroup:FlxSpriteGroup;
    var curWarning:Int = 1;

    override public function create():Void
    {
        #if (cpp && windows) //wednesday infidelity cool code!
		CppAPI.darkMode();
		#end

        FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		super.create();

		FlxG.save.bind('FNFBC-DA', CoolUtil.getSavePath());
		ClientPrefs.loadPrefs();
		Highscore.load();

        FlxG.mouse.visible = false; //double check

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

        if(FlxG.save.data.introWarnings == false) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new TitleState());
		}

        camera.flash(FlxColor.BLACK, 0.7, null, true);

        chains = new FlxSprite(0, 0);
        chains.antialiasing = ClientPrefs.data.antialiasing;
        chains.loadGraphic(Paths.image("menus/titleScreen/warning/chains"));
        chains.screenCenter();
        chains.alpha = 0.5; //now its accurated B)
        add(chains);

        warningsGroup = new FlxSpriteGroup();
        add(warningsGroup);

        var xPos:Array<Float> = [FlxG.width * 2, FlxG.width * -2, FlxG.width * 2, FlxG.width * -2, 180];
        for (i in 0...5) {
            var warning = new FlxSprite(xPos[i]);
            warning.loadGraphic(Paths.image("menus/titleScreen/warning/warningImage" + (i + 1)));
            warning.setGraphicSize(Std.int(warning.width * 0.5));
            warning.updateHitbox();
            warning.screenCenter(Y);
            warning.scrollFactor.set(0.9, 0.9);
            warning.antialiasing = ClientPrefs.data.antialiasing;
            warningsGroup.add(warning);
        }
        warningsGroup.members[4].alpha = 0;
        FlxTween.tween(warningsGroup.members[0], {x: 180}, 0.0001, {ease: FlxEase.quadOut});
    }    

    override function update(elapsed:Float)
    {
        if(controls.ACCEPT && curWarning < 6) {
            var daWarning = warningsGroup.members[curWarning];

            FlxG.sound.play(Paths.sound("confirmMenu"));
            if (curWarning != 5)
                camera.flash(FlxColor.BLACK, 1, null, true);

            switch (curWarning) {
                case 1 | 2 | 3:
                    warningsGroup.members[curWarning - 1].visible = false;
                    FlxTween.tween(daWarning, {x: 180}, 0.5, {ease: FlxEase.quadOut});
                case 4:
                    chains.visible = false;
                    warningsGroup.members[curWarning - 1].visible = false;
                    daWarning.alpha = 1;
                case 5:
                    FlxTween.tween(warningsGroup.members[curWarning - 1], {alpha: 0}, 2.2, {
                        ease: FlxEase.smoothStepOut,
                        onComplete: function (tween:FlxTween)
                        {
                            MusicBeatState.switchState(new TitleState());
                        }
                    });
            }
            curWarning++;
        }
        super.update(elapsed);
	}
}