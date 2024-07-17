function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Pico Bullets' then --Check if the note on the chart is a Bullet Note
                   setPropertyFromGroup('unspawnNotes', i, 'texture', 'BULLETS_assets'); --Change texture

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Pico Bullets' then
		if difficulty == 2 then
			playSound('shoot', 0.8);
		end
		characterPlayAnim('dad', 'shoot', true);
		characterPlayAnim('boyfriend', 'dodge', true);
		setProperty('boyfriend.specialAnim', true);
		setProperty('dad.specialAnim', true);
		cameraShake('camGame', 0.001, 0.02)
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Pico Bullets' then
		setProperty('health', getProperty('health')-0.2);
		runTimer('bleed', 0.2, 20);
		playSound('shoot', 0.8);
		characterPlayAnim('boyfriend', 'hurt', true);
                characterPlayAnim('dad', 'shoot', true);
		setProperty('boyfriend.specialAnim', true);
		setProperty('dad.specialAnim', true);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if loopsLeft >= 1 then
		setProperty('health', getProperty('health')-0.001);
	end
end