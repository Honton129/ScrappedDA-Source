function onCreate()
   makeLuaSprite('overlayFun', 'stageoverlaycorrupt');
   setObjectCamera('overlayFun', 'camHUD');
   addLuaSprite('overlayFun', false);

   setProperty('camGame.alpha', 0.0001);
   setProperty('camHUD.alpha', 0.0001);
   setProperty('camOther.alpha', 0.0001);
end

function onBeatHit()
   if curBeat == 1 then
      doTweenAlpha('hello', 'camGame', 1, 1.5, 'circInOut');
      doTweenAlpha('hello1', 'camHUD', 1, 1.5, 'circInOut');
      doTweenAlpha('hello2', 'camOther', 1, 1.5, 'circInOut');
   end
   if curBeat == 64 then
      setProperty('overlayFun.alpha', 0);
   end
   if curBeat == 128 then
      setProperty('overlayFun.alpha', 1);
   end
   if curBeat == 224 then
      setProperty('overlayFun.alpha', 0);
   end
   if curBeat == 288 then
      setProperty('overlayFun.alpha', 1);
   end
   if curBeat == 320 then
      setProperty('camHUD.alpha', 0);
      setProperty('camGame.alpha', 0);
      setProperty('camOther.alpha', 0);
   end
end

function opponentNoteHit()
    health = getProperty('health')
    if getProperty('health') > 0.4 and curBeat > 64 then
        setProperty('health', health- 0.020);
    end
end