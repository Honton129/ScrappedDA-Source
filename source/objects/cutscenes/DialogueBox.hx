package objects.cutscenes;

import flixel.addons.text.FlxTypeText;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	public static var onPlayState:Bool = true;
	public var curCharacter:String = '';

	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var dropText:FlxText;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var faceNormal:FlxSprite;

	//CUSTOM PORTRAITS!
	var portraitWell:FlxSprite; //Well Well We- kill me.
	var portraitFaceless:FlxSprite;
	var portraitGlitch:FlxSprite;
	var portraitAdmin:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'blissful-ignorance':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'banishment' | 'savestate':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		//senpai normal
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/pixelUI/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter instance 1', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		//eduardo-pai normal
		portraitWell = new FlxSprite(-20, 40);
		portraitWell.frames = Paths.getSparrowAtlas('weeb/pixelUI/senpaiEvilPortrait');
		portraitWell.animation.addByPrefix('enter', 'Senpai Portrait Enter instance 1', 24, false);
		portraitWell.setGraphicSize(Std.int(portraitWell.width * PlayState.daPixelZoom * 0.9));
		portraitWell.updateHitbox();
		portraitWell.scrollFactor.set();
		add(portraitWell);
		portraitWell.visible = false;

		//bf normal
		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/pixelUI/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		//bf faceless
		portraitFaceless = new FlxSprite(0, 40);
		portraitFaceless.frames = Paths.getSparrowAtlas('weeb/pixelUI/bfPortrait2');
		portraitFaceless.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
		portraitFaceless.setGraphicSize(Std.int(portraitFaceless.width * PlayState.daPixelZoom * 0.9));
		portraitFaceless.updateHitbox();
		portraitFaceless.scrollFactor.set();
		add(portraitFaceless);
		portraitFaceless.visible = false;

		//bf glitch
		portraitGlitch = new FlxSprite(0, 40);
		portraitGlitch.frames = Paths.getSparrowAtlas('weeb/pixelUI/bfPortrait3');
		portraitGlitch.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
		portraitGlitch.setGraphicSize(Std.int(portraitGlitch.width * PlayState.daPixelZoom * 0.9));
		portraitGlitch.updateHitbox();
		portraitGlitch.scrollFactor.set();
		add(portraitGlitch);
		portraitGlitch.visible = false;

		//bf admin
		portraitAdmin = new FlxSprite(0, 40);
		portraitAdmin.frames = Paths.getSparrowAtlas('weeb/pixelUI/bfPortrait4');
		portraitAdmin.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
		portraitAdmin.setGraphicSize(Std.int(portraitAdmin.width * PlayState.daPixelZoom * 0.9));
		portraitAdmin.updateHitbox();
		portraitAdmin.scrollFactor.set();
		add(portraitAdmin);
		portraitAdmin.visible = false;

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;

		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'blissful-ignorance':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);

			case 'disconnection':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiAngry');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH0', [4], "", 24);

			case 'short-circuit':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH0', [4], "", 24);

			case 'banishment' | 'savestate':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn instance 1', [11], "", 24);

				faceNormal = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/pixelUI/spiritFaceForward'));
				faceNormal.setGraphicSize(Std.int(faceNormal.width * 6));
				add(faceNormal);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		//box lmao
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	override function update(elapsed:Float)
	{
		if (PlayState.SONG.song.toLowerCase() == 'disconnection' || PlayState.SONG.song.toLowerCase() == 'short-circuit')
			portraitLeft.visible = false;

		if (PlayState.SONG.song.toLowerCase() == 'banishment' || PlayState.SONG.song.toLowerCase() == 'savestate')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(Controls.instance.ACCEPT)
		{
			if (dialogueEnded)
			{
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						FlxG.sound.play(Paths.sound('clickText'), 0.8);	

						if (PlayState.SONG.song.toLowerCase() == 'blissful-ignorance' || PlayState.SONG.song.toLowerCase() == 'banishment' || PlayState.SONG.song.toLowerCase() == 'savestate')
						{
							FlxG.sound.music.fadeOut(1.5, 0);
						}

						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 1 / 5;
							bgFade.alpha -= 1 / 5 * 0.7;
							portraitLeft.visible = false;
							portraitWell.visible = false;
							portraitRight.visible = false;
							portraitFaceless.visible = false;
							portraitGlitch.visible = false;
							portraitAdmin.visible = false;
							swagDialogue.alpha -= 1 / 5;
							handSelect.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
				swagDialogue.skip();
				
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function() {
			handSelect.visible = true;
			dialogueEnded = true;
		};

		handSelect.visible = false;
		dialogueEnded = false;
		switch (curCharacter)
		{
			case 'senpai':
				portraitRight.visible = false;
				portraitFaceless.visible = false;
				portraitGlitch.visible = false;
				portraitWell.visible = false;
				portraitAdmin.visible = false;
				if (!portraitLeft.visible)
				{
					if (PlayState.SONG.song.toLowerCase() == 'blissful-ignorance')
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}

					if (PlayState.SONG.song.toLowerCase() == 'banishment' || PlayState.SONG.song.toLowerCase() == 'savestate')
					{
						faceNormal.visible = true;
					} 
				}

			case 'senpai-evil':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				portraitFaceless.visible = false;
				portraitGlitch.visible = false;
				portraitAdmin.visible = false;
				if (!portraitWell.visible)
				{
					if (PlayState.SONG.song.toLowerCase() == 'blissful-ignorance')
					{
						portraitWell.visible = true;
						portraitWell.animation.play('enter');
					}

					if (PlayState.SONG.song.toLowerCase() == 'banishment' || PlayState.SONG.song.toLowerCase() == 'savestate')
					{
						faceNormal.visible = true;
					} 
				}

			case 'bf':
				portraitLeft.visible = false;
				portraitFaceless.visible = false;
				portraitGlitch.visible = false;
				portraitWell.visible = false;
				portraitAdmin.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}

			case 'bf-faceless':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitWell.visible = false;
				portraitGlitch.visible = false;
				portraitAdmin.visible = false;
				if (!portraitFaceless.visible)
				{
					portraitFaceless.visible = true;
					portraitFaceless.animation.play('enter');
				}

			case 'bf-glitch':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitWell.visible = false;
				portraitFaceless.visible = false;
				portraitAdmin.visible = false;
				if (!portraitGlitch.visible)
				{
					portraitGlitch.visible = true;
					portraitGlitch.animation.play('enter');
				}

			case 'bf-admin':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitFaceless.visible = false;
				portraitWell.visible = false;
				portraitGlitch.visible = false;
				if (!portraitAdmin.visible)
				{
					portraitAdmin.visible = true;
					portraitAdmin.animation.play('enter');
				}
		}
		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}