function onCreatePost()
	makeLuaSprite('whitebg', '', 0, 0);
	setScrollFactor('whitebg', 0, 0);
	makeGraphic('whitebg', 10000, 10000, 'ffffff');
	addLuaSprite('whitebg', false);
	setProperty('whitebg.alpha', 0);
	screenCenter('whitebg', 'xy');

	dadColor = getProperty("dad.healthColorArray");
	bfColor = getProperty("boyfriend.healthColorArray");
end

function onEvent(n, v1, v2)
	if n == 'Set Silhouettes' and string.lower(v1) == 'a' then
		doTweenAlpha('whiteBGAppear', 'whitebg', 1, v2, 'linear');
		doTweenAlpha('healthBarDissapears', 'healthBar', 0, v2, 'linear');
		doTweenAlpha('iconP1Dissapears', 'iconP1', 0, v2, 'linear');
		doTweenAlpha('iconP2Dissapears', 'iconP2', 0, v2, 'linear');
	end

	if n == 'Set Silhouettes' and string.lower(v1) == 'b' then
		doTweenAlpha('whiteBGDissapears', 'whitebg', 0, v2, 'linear');
		doTweenAlpha('healthBarAppear', 'healthBar', 1, v2, 'linear');
		doTweenAlpha('iconP1Appear', 'iconP1', 1, v2, 'linear');
		doTweenAlpha('iconP2Appear', 'iconP2', 1, v2, 'linear');
	end
end

function rgbToHex(r, g, b)
	return string.format("%02x%02x%02x", 
		math.floor(r),
		math.floor(g),
		math.floor(b));
end