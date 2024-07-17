function opponentNoteHit()
    health = getProperty('health')
    if getProperty('dad.curCharacter') == 'spooky3' and getProperty('health') > 0.4 then
        setProperty('health', health- 0.020);
    end
end