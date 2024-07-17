function onStartCountdown()
   setProperty('healthBar.alpha', 0);
   setProperty('iconP1.alpha', 0);
   setProperty('iconP2.alpha', 0);
   setProperty('scoreTxt.alpha', 0);
   setProperty('pogaCorrupted.alpha', 0.00001);
   setProperty('skidLmao.alpha', 0.00001);
   setProperty('yupodElao.alpha', 0.00001);
   setProperty('mathxMiedoPng.alpha', 0.00001);
   setProperty('phillyStreet.alpha', 0.00001);
   setProperty('city.alpha', 0.00001);
   setProperty('bg.alpha', 0.00001);
   setProperty('boyfriend.color', 404040);
   setProperty('gf.color', 404040);
   setProperty('dad.color', 404040);
end

function onCreate()
    makeLuaSprite('blur', 'deadblur', -500, -300)
    scaleObject('blur', 2, 2)
    addLuaSprite('blur', true)
    setScrollFactor('blur', 0, 0)
    setProperty('blur.alpha', 0.00001)
end

function onUpdate()
    if getProperty('health') < 0.5 then
        doTweenAlpha('heloAlpha', 'blur', 1, stepCrochet*0.01, 'linear')
    end

    if getProperty('health') > 0.5 then
        doTweenAlpha('bayAlpha','blur', 0, stepCrochet*0.01, 'linear')
    end
end

function onBeatHit()
    if curBeat == 64 then
        setProperty('pogaCorrupted.alpha', 1);
        setProperty('skidLmao.alpha', 1);
        setProperty('yupodElao.alpha', 1);
        setProperty('mathxMiedoPng.alpha', 1);
        setProperty('phillyStreet.alpha', 1);
        setProperty('city.alpha', 1);
        setProperty('bg.alpha', 1);
        doTweenColor('badapplexd3', 'boyfriend', 'FFFFFF', 0.00001, 'linear')
        doTweenColor('badapplexd4', 'dad', 'FFFFFF', 0.00001, 'linear')
        doTweenColor('badapplexd5', 'gf', 'FFFFFF', 0.00001, 'linear')
    end

    if curBeat == 480 then
        setProperty('camGame.visible', false)
    end 
end

function opponentNoteHit()
    health = getProperty('health')
    if getProperty('health') > 0.4 then
        setProperty('health', health- 0.020);
    end
end