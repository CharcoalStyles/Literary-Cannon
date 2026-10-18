package utils;

import csHxUtils.entities.CsEmitter;
import flixel.FlxBasic;
import openfl.Assets;

typedef LetterData =
{
	var points:Int;
	var initialCount:Int;
}

class GlobalState extends FlxBasic
{
	public var isUsingController:Bool = false;
	public var controllerId:Int = 0;
	public var emitter:CsEmitter;

	public var playerDetails:PlayerDetails;
	public var dictionary:Map<String, Bool>;

	public function new()
	{
		super();
		emitter = new CsEmitter();

		var lettersData = Assets.getText("assets/data/letters.json");
		var lettersObj:Dynamic = haxe.Json.parse(lettersData);
		var userLetters:Array<LetterDetails> = [];
		for (letter in Reflect.fields(lettersObj))
		{
			var data:LetterData = Reflect.field(lettersObj, letter);
			for (i in 0...data.initialCount)
			{
				userLetters.push(new LetterDetails(letter, data.points));
			}
		}

		playerDetails = new PlayerDetails("Player", 25, 25, userLetters);
		dictionary = new Map<String, Bool>();
		var words:Array<String> = haxe.Json.parse(Assets.getText("assets/data/words.json"));
		for (word in words)
		{
			dictionary.set(word, true);
		}
	}

	public function createEmitter()
	{
		emitter = new CsEmitter();
	}
}
