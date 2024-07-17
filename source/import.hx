#if !macro

//Discord API
#if DISCORD_ALLOWED
import backend.api.discord.Discord;
#end

//Cpp API
#if cpp
import backend.api.cpp.CppAPI;
#end

//FlxAnimate
#if flxanimate
import flxanimate.*;
#end

//Psych Lua
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
import psychlua.*;
#else
import psychlua.FunkinLua;
import psychlua.LuaUtils;
import psychlua.HScript;
#end

//Mods
#if MODS_ALLOWED
import backend.Mods;
#end

//Sys
#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

//SScript
#if (HSCRIPT_ALLOWED && SScript)
import tea.SScript;
#end

//Backends
import backend.Paths;
import backend.Controls;
import backend.CoolUtil;
import backend.ClientPrefs;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.CustomFadeTransition;
import backend.animation.PsychAnimationController;
import backend.NoteTypesConfig;
import backend.BaseStage;
import backend.PsychCamera;

//Playstate Backends
import backend.Difficulty;
import backend.Rating;
import backend.StageData;
import backend.WeekData;
import backend.Highscore;
import backend.SongMetadata;

//Songs Backends
import backend.Conductor;
import backend.Conductor.BPMChangeEvent;
import backend.Section.SwagSection;
import backend.Song.SwagSong;
import backend.Song;

//Objects
import objects.Alphabet;
import objects.BGSprite;
import objects.Bar;
import objects.HealthIcon;
import objects.Character;
import objects.Note.EventNote;
import objects.StrumNote;
import objects.NoteSplash;
import objects.Note;
import objects.AttachedSprite;
import objects.MenuItem;

//States
import states.PlayState;
import states.LoadingState;

//Damn fine i'll add this
import substates.GameOverSubstate;
import backend.options.BaseOptionsMenu;
import backend.options.Option;

//Flixel
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

//Lime Application
import lime.app.Application;

#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

//HxCodec
#if VIDEOS_ALLOWED 
#if (hxCodec >= "3.0.0") 
import hxcodec.flixel.FlxVideo as VideoHandler;
import hxcodec.flixel.FlxVideoSprite as VideoSprite;
#elseif (hxCodec >= "2.6.1")
import hxcodec.VideoHandler as VideoHandler;
import hxcodec.VideoSprite as VideoSprite;
#elseif (hxCodec == "2.6.0")
import VideoHandler;
import VideoSprite;
#else
import vlc.MP4Handler as VideoHandler
import vlc.MP4Sprite as VideoSprite; #end
#end

using StringTools;
#end