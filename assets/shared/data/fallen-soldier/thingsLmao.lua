function onStartCountdown()
    setProperty('boyfriend.alpha', 0.0001)
    setProperty('gf.alpha', 0.0001)
    setProperty('dad.alpha', 0.0001)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)
    setProperty('healthBar.visible', false)
    setProperty('scoreTxt.visible', false)
end

function onCreate()
    makeLuaSprite('blur', 'deadblur')
    addLuaSprite('blur', true)
    setScrollFactor('blur', 0, 0)
    setProperty('blur.alpha', 0.00001)
    setObjectCamera('blur','other')
end

function onBeatHit()
    if curBeat == 80 then
        setProperty('iconP1.visible', true)
        setProperty('iconP2.visible', true)
        setProperty('healthBar.visible', true)
        setProperty('scoreTxt.visible', true)
    end
    if curBeat == 256 then
        setProperty('blur.alpha', 1)
    end
    if curBeat == 352 then
        setProperty('camGame.alpha', 0)
        setProperty('camHUD.alpha', 0)
    end
end

function opponentNoteHit()
    health = getProperty('health')
    if getProperty('dad.curCharacter') == 'picod3' and getProperty('health') > 0.4 then
        setProperty('health', health- 0.050);
    end
end