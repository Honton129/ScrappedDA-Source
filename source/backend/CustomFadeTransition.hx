package backend;

import shaders.DiamondTransShader;

class CustomFadeTransition extends MusicBeatSubstate
{
    public static var finishCallback:() -> Void;
    public static var nextCamera:FlxCamera;
    private var leTween:FlxTween = null;

    var shader:DiamondTransShader;
    var transBlack:FlxSprite;
    var rect:FlxSprite;

    var fi:Bool = true;
    var duration:Float;

    public function new(duration:Float = 1.0, isTransIn:Bool = true)
    {
        super();

        camera = new FlxCamera();
        camera.bgColor = FlxColor.TRANSPARENT;

        FlxG.cameras.add(camera, false);

        this.duration = duration;
        this.fi = isTransIn;

        shader = new DiamondTransShader();

        shader.progress.value = [0.0];
        shader.reverse.value = [false];

        rect = new FlxSprite();
        rect.makeGraphic(1, 1, 0xFF000000);
        rect.scale.set(1280, 720);
        rect.origin.set();
        rect.shader = shader;
        rect.visible = false;
        add(rect);

        transBlack = new FlxSprite();
        transBlack.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		transBlack.origin.set();
        transBlack.visible = false;
		add(transBlack);

        if(fi)
        {
            fadeIn();
        }
        else
        {
            fadeOut();
        }

        if(nextCamera != null) {
			rect.cameras = [nextCamera];
            transBlack.cameras = [nextCamera];
		}
		nextCamera = null;

        closeCallback = _closeCallback;
    }

    function __fade(from:Float, to:Float, reverse:Bool)
    {   
        rect.visible = true;
        shader.progress.value = [from];
        shader.reverse.value = [reverse];

        if(fi)
        {
            leTween = FlxTween.num(from, to, duration, {
                onComplete: function(_) {
                close();
            }, ease: FlxEase.linear}, 
                function(num:Float) {
                shader.progress.value = [num];
            });
        }
        else 
        {
            leTween = FlxTween.num(from, to, duration, {
                onComplete: function(_) {
                if(finishCallback != null) {
                    finishCallback();
                }
            }, ease: FlxEase.linear}, 
                function(num:Float) {
                shader.progress.value = [num];
            });
        }
    }

    function fadeIn()
    {
        __fade(0.0, 1.0, true);
    }

    function fadeOut()
    {
        __fade(0.0, 1.0, false);
    }

    function _closeCallback()
    {
        if (leTween != null)
            leTween.cancel();
    }
}