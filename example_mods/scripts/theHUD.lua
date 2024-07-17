--BEFORE ENTER HERE I JUST WANNA SAY THAT THIS IS A LUA THAT MIXES OTHER LUAS FOR SAVE LOADING TIMES!!

--[CREDITS DOWN HERE! ! !]--

--Mixed Lua by Honton129
--Song Credits Text Lua Originaly made by omotashi, legole0, Piggyfriend1792 and DEAD SKULLXX on GameBanana

--[Song Credits Configuration]--
local songdata = {
--yes i used the pico week bc i didnt wanna interfere with the old version
    ['Tutorial'] = {
    'Tutorial', -- Song Name [1]
    'Rozebud', -- Composer [2]
    '4', --  Length for onscreen [3]
    'Check The Credits!', -- Artist [4]
    'Cval', -- Charter [5]
    },

    ['Fight-Or-Flight'] = {
        'Fight-Or-Flight',
        'FurretGiovana',
        '4',
        'Check The Credits!',
        'SMG2',
    },

    ['Showdown'] = {
        'Showdown',
        'FurretGiovana',
        '4',
        'Check The Credits!',
        'Honton129',
    },

    ['Fallen-Soldier'] = {
        'Fallen Soldier',
        'FurretGiovana',
        '4',
        'Check The Credits!',
        'SMG2 & Benkamyn',
    },

    ['corrupt-spookeez'] = {
        'Corrupt Spookeez',
        'FurretGiovana',
        '4',
        'Check The Credits!',
        'SMG2 & Benkamyn',
    },

    ['corrupt-south'] = {
        'Corrupt South',
        'FurretGiovana',
        '4',
        'Check The Credits!',
        'SMG2 & Honton129',
    },

    ['Chiller'] = {
        'Chiller',
        'Zhadnii, Benkamyn & FurretGiovana',
        '4',
        'Check The Credits!',
        'Zhadnii',
    },

    ['Matricidal'] = {
        'Matricidal',
        'Zhadnii, Benkamyn & FurretGiovana',
        '4',
        'Check The Credits!',
        'SMG2',
    },

    ['Bullet-Past'] = {
        'Bullet Past',
        'Zhadnii',
        '4',
        'Check The Credits!',
        'SMG2',
    },

    ['Test'] = {
        'Test',
        'Kawaii Sprite',
        '4',
        'Check The Credits!',
        'NinjaMuffin99',
    },

    ['fading-to-black'] = {
        'Fading To Black',
        'Zhadnii',
        '4',
        'Check The Credits!',
        'Zhadnii',
    },

    ['chiller-remix'] = {
        'Chiller Remix',
        'Poga',
        '4',
        'Check The Credits!',
        'SMG2',
    },

    ['sal-de-mi-casa'] = {
        'Sal de mi Casa',
        'Poga',
        '4',
        'Check The Credits!',
        'SMG2',
    },

    ['Remix-10-DS'] = {
        'Remix 10',
        'Masami Yone',
        '4',
        'Check The Credits!',
        'Honton129',
    },

    ['Death-Toll'] = {
        'Death Toll',
        'punkett',
        '4',
        'Check The Credits!',
        'Unknown',
    },
    
-- Replace this data with your songs and the song composer. 
-- The song name in the [] MUST be the same song in the JSON file
-- The Next two are just string values, have fun :3
}

--[Song Credits Lua Shits]--
local offsetX = 10
local offsetY = 500
local objWidth = 500

function ifExists(table, valuecheck) -- This stupid function stops your game from throwing up errors when you play a main week song thats not in the Song Data Folder
    if table[valuecheck] then
        return true
    else
        return false
    end
end

function onCreate()
    --Song Credits Text Assets
	makeLuaSprite('JukeBoxTag', '', -305-IntroTagWidth, 15)
	makeGraphic('JukeBoxTag', 300+IntroTagWidth, 100, IntroTagColor)
	setObjectCamera('JukeBoxTag', 'other')
	addLuaSprite('JukeBoxTag', true)

	makeLuaSprite('JukeBox', '', -305-IntroTagWidth, 15)
	makeGraphic('JukeBox', 300, 100, '000000')
	setObjectCamera('JukeBox', 'other')
	addLuaSprite('JukeBox', true)
	
	makeLuaText('JukeBoxText', 'Now Playing:', 400, -305-IntroTagWidth, 30)
	setTextAlignment('JukeBoxText', 'left')
	setObjectCamera('JukeBoxText', 'other')
	setTextSize('JukeBoxText', IntroTextSize)
	addLuaText('JukeBoxText')
	
	makeLuaText('JukeBoxSubText', songName, 400, -305-IntroTagWidth, 60)
	setTextAlignment('JukeBoxSubText', 'left')
	setObjectCamera('JukeBoxSubText', 'other')
	setTextSize('JukeBoxSubText', IntroSubTextSize)
	addLuaText('JukeBoxSubText')
end

function onCreatePost()
    --[Song Credits Lua Assets]--
    --This creates all the placeholder shit B) ((THIS PART ON THE ORIGINAL SCRIPT WAS MADE BY PIGGY))
    luaDebugMode = true

    makeLuaSprite('creditBox', '', 0 - objWidth, offsetY)
    makeGraphic('creditBox', objWidth, 150, '000000')
    setObjectCamera('creditBox', 'other')
    setProperty("creditBox.alpha", 0.7)
    addLuaSprite('creditBox', true)

    makeLuaText('creditTitle', 'PlaceholderTitle', objWidth, offsetX - objWidth, offsetY+0)
    setTextSize('creditTitle', 45)
    setTextAlignment('creditTitle', 'left')
    setObjectCamera('creditTitle', 'other')
    addLuaText("creditTitle",true)

    makeLuaText('creditComposer', 'PlaceholderComposer', objWidth, offsetX - objWidth, offsetY+45)
    setTextSize('creditComposer', 30)
    setTextAlignment('creditComposer', 'left')
    setObjectCamera('creditComposer', 'other')
    addLuaText("creditComposer",true)

    makeLuaText('creditArtist', 'PlaceholderArtist', objWidth, offsetX - objWidth, offsetY+80)
    setTextSize('creditArtist', 30)
    setTextAlignment('creditArtist', 'left')
    setObjectCamera('creditArtist', 'other')
    addLuaText("creditArtist",true)

    makeLuaText('creditCharter', 'PlaceholderCharter', objWidth, offsetX - objWidth, offsetY+115)
    setTextSize('creditCharter', 30)
    setTextAlignment('creditCharter', 'left')
    setObjectCamera('creditCharter', 'other')
    addLuaText("creditCharter",true)

    -- If you dont NOT want the art and charter credits (or a mix of two), the value used in the old version is:
    -- offsetY+25 for creditTitle
    -- offsetY+80 for the other credit (be it Composer, Charting, or Art)

    setProperty('scoreTxt.visible', false) --bye bye score for now
end

--[Song Credits Text Function]--
function onSongStart()

 songExists = ifExists(songdata, songName) -- Checks to see if song exists

 if songExists == true then
    local curSongTable = songdata[songName]
    setTextString('creditTitle', curSongTable[1]) -- Sets the actual things
    setTextString('creditComposer', "Song: "..curSongTable[2])
    setTextString('creditCharter', "Charting: "..curSongTable[5])

    --Tweens--
    doTweenX("creditBoxTween", "creditBox", getProperty("creditBox.x") + objWidth, 1, "expoOut")
    doTweenX("creditTitleTween", "creditTitle", getProperty("creditTitle.x") + objWidth, 1, "expoOut")
    doTweenX("creditComposerTween", "creditComposer", getProperty("creditComposer.x") + objWidth, 1, "expoOut")
    doTweenX("creditCharterTween", "creditCharter", getProperty("creditCharter.x") + objWidth, 1, "expoOut")
    runTimer("creditDisplay",curSongTable[3],1)
    else
    end
end

function onTimerCompleted(timerName)

    if timerName == "creditDisplay" then
        doTweenX("creditBoxTween", "creditBox", getProperty("creditBox.x") - objWidth, 0.5, "sineIn")
        doTweenX("creditTitleTween", "creditTitle", getProperty("creditTitle.x") - objWidth, 0.5, "sineIn")
        doTweenX("creditComposerTween", "creditComposer", getProperty("creditComposer.x") - objWidth, 0.5, "sineIn")
        doTweenX("creditCharterTween", "creditCharter", getProperty("creditCharter.x") - objWidth, 0.5, "sineIn")
    end
end