function opponentNoteHit()
    health = getProperty('health')
    if getProperty('dad.curCharacter') == 'spooky2' and getProperty('health') > 0.02 then
        setProperty('health', health- 0.02);
    end
end