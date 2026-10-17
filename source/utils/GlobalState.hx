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
		var lettersObj:Map<String, LetterData> = haxe.Json.parse(lettersData);
		var userLetters:Array<LetterDetails> = [];
		for (letter in lettersObj.keys())
		{
			var data:LetterData = Reflect.field(lettersObj, letter);
			for (i in 0...lettersObj[letter].initialCount)
			{
				userLetters.push(new LetterDetails(letter, data.points));
			}
		}

		playerDetails = new PlayerDetails("Player", 25, 25, userLetters);
		dictionary = new Map<String, Bool>();
		for (word in Assets.getText("assets/data/words.txt").split("\n"))
		{
			dictionary.set(word, true);
		}
	}

	public function createEmitter()
	{
		emitter = new CsEmitter();
	}
}
