package shaders;

import flixel.system.FlxAssets.FlxShader;

/**
 * SHADER TOOK FROM: "https://www.youtube.com/watch?v=HCDvIWtTN00"
 * RE-ADAPTED BY HONTON129
 */

class ChromaticAbberation extends FlxBasic
{
    public var shader(default, null):ChromaticShader = new ChromaticShader();
    public var iTime(default, set):Float = 0;

    public function new(_iTime:Float = 0):Void{
        super();
        iTime = _iTime;
    }

    override public function update(elapsed:Float):Void{
        super.update(elapsed);
    }
    
    function set_iTime(v:Float):Float{
		iTime = v;
        shader.rOffset.value = [iTime];
		shader.gOffset.value = [iTime];
		shader.bOffset.value = [iTime];
		return v;
	}
}

class ChromaticShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header

    uniform float rOffset;
    uniform float gOffset;
    uniform float bOffset;

    void main()
    {
        vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(rOffset * 0.5, 0.0));
        vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st + vec2(gOffset, 0.0));
        vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st + vec2(bOffset * 2.5, 0.0));
        vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
        toUse.r = col1.r;
        toUse.g = col2.g;
        toUse.b = col3.b;

        gl_FragColor = toUse;
    }')

    public function new()
    {
        super();
    }
}