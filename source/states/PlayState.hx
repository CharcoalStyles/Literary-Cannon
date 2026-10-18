package states;

import entities.Tile;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import states.subStates.PauseState;
import utils.GlobalState;

enum Play_State
{
	Intro;
	PlayerTurnInit;
	PlayerTurn;
	PlayerAction;
	EnemyTurn;
	End;
}

class PlayState extends FlxState
{
	var globalState:GlobalState;

	var tileBag:Array<Tile> = [];
	var tileDiscard:Array<Tile> = [];

	var currentHand:Array<Tile> = [];
	var currentHandLimit:Int = 8;

	var currentPlay:Array<Tile> = [];

	var currentState:Play_State;
	var nextState:Play_State;
	var transitionCountdown:Float;

	var enemyHp:Int = 40;
	var enemyAttack:Int = 6;

	var stateText:FlxText;

	var score:Int = 0;
	var scoreText:FlxText;

	var scoreTextPool:FlxTypedGroup<FlxText>;

	var playWordButton:FlxButton;

	var countingIndex:Int = 0;

	public function new()
	{
		super();
		globalState = FlxG.plugins.get(GlobalState);

		currentState = Play_State.Intro;
		transitionCountdown = 2;
	}

	override public function create()
	{
		super.create();
		FlxG.mouse.visible = true;

		for (letter in globalState.playerDetails.tileBag)
		{
			var tile = new Tile(0, 0);
			tile.setTileDetails(letter);
			tile.kill();
			add(tile);
			tileBag.push(tile);
		}

		FlxG.random.shuffle(tileBag);

		currentHand = [];

		globalState = FlxG.plugins.get(GlobalState);
		stateText = new FlxText(0, 0, 0, currentState.getName(), 16);
		stateText.setFormat(null, 16, 0xff000000, LEFT, OUTLINE, 0xffffffff);
		add(stateText);

		playWordButton = new FlxButton(0, 0, "Play Word", function()
		{
			countingIndex = 0;
			transitionCountdown = 1;
			nextState = Play_State.PlayerAction;
		});
		playWordButton.x = FlxG.width - playWordButton.width;
		playWordButton.y = FlxG.height - playWordButton.height;
		playWordButton.kill();
		add(playWordButton);

		scoreText = new FlxText(FlxG.width / 2, 0, 0, "Score: " + score, 16);
		scoreText.setFormat(null, 32, 0xff000000, CENTER, OUTLINE, 0xffffffff);
		add(scoreText);

		scoreTextPool = new FlxTypedGroup<FlxText>();
		for (i in 0...10)
		{
			var text = new FlxText(0, 0, 0, "0", 16);
			text.setFormat(null, 32, 0xffffffff, LEFT, OUTLINE, 0xff000000);
			text.kill();
			scoreTextPool.add(text);
		}
		add(scoreTextPool);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (nextState != null)
		{
			currentState = nextState;
			nextState = null;
			stateText.text = currentState.getName();
		}

		switch (currentState)
		{
			case Intro:
				transitionCountdown -= elapsed;
				if (transitionCountdown <= 0)
				{
					transitionCountdown = 0.3;
					nextState = Play_State.PlayerTurnInit;
				}
			case PlayerTurnInit:
				transitionCountdown -= elapsed;
				if (transitionCountdown <= 0)
				{
					transitionCountdown = 0.1;
					if (currentHand.length < currentHandLimit)
					{
						// var difference = currentHandLimit - currentHand.length;
						// for (i in 0...difference)
						// {
						var tile = tileBag.shift();
						tile.revive();
						sendTileToHand(tile);
						// }
						setHandTiles();
					}
					else
					{
						nextState = Play_State.PlayerTurn;
					}
				}
			case PlayerTurn:
				if (FlxG.mouse.justPressed)
				{
					var handTileToSwitch:Null<Tile> = null;
					var playTileToSwitch:Null<Tile> = null;
					for (tile in currentHand)
					{
						if (tile.overlapsPoint(FlxG.mouse.getWorldPosition(FlxG.camera), true, FlxG.camera))
						{
							handTileToSwitch = tile;
							break;
						}
					}

					for (tile in currentPlay)
					{
						if (tile.overlapsPoint(FlxG.mouse.getWorldPosition(FlxG.camera), true, FlxG.camera))
						{
							playTileToSwitch = tile;
							break;
						}
					}

					if (handTileToSwitch != null)
					{
						sendTileToPlay(handTileToSwitch);
						currentHand.remove(handTileToSwitch);
					}

					if (playTileToSwitch != null)
					{
						sendTileToHand(playTileToSwitch);
						currentPlay.remove(playTileToSwitch);
					}

					setHandTiles();
					setPlayTiles();

					var currentWord = "";
					for (tile in currentPlay)
					{
						currentWord += tile.letterText.text;
					}

					if (isWordValid(currentWord))
					{
						playWordButton.revive();
					}
					else
					{
						playWordButton.kill();
					}
				}
			case PlayerAction:
				transitionCountdown -= elapsed;
				if (transitionCountdown <= 0)
				{
					transitionCountdown = 0.3;
					var tile = currentPlay[countingIndex];
					var scoreString = tile.pointsSprite.text;
					var tileScore = Std.parseInt(scoreString);

					var scoreText = scoreTextPool.recycle();
					scoreText.text = scoreString;
					scoreText.x = tile.x;
					scoreText.y = tile.y;
					scoreText.scale.set(2, 2);

					score += tileScore;
					this.scoreText.text = "Score: " + score;

					scoreText.text = scoreString;
					countingIndex++;
					if (countingIndex >= currentPlay.length)
					{
						transitionCountdown = 0.3;
						nextState = Play_State.EnemyTurn;
					}
				}
			case EnemyTurn:
				transitionCountdown -= elapsed;
				if (transitionCountdown <= 0)
				{
					transitionCountdown = 0.1;
					var tile = currentPlay.pop();
					tile.kill();
					tileBag.push(tile);
					setPlayTiles();

					if (currentPlay.length == 0)
					{
						FlxG.random.shuffle(tileBag);
						transitionCountdown = 0.3;
						nextState = Play_State.PlayerTurnInit;
					}
				}
			case End:
				transitionCountdown = 0;
		}

		scoreTextPool.forEachAlive(function(text:FlxText)
		{
			if (text.scale.y <= 0.1)
			{
				text.kill();
			}
			text.scale.scale(0.975);
			text.y -= (elapsed + text.scale.y) * 3;
		});

		if (FlxG.keys.justPressed.ESCAPE)
		{
			this.subState = new PauseState(globalState.controllerId);
			this.subState.create();
			this.subState.closeCallback = () ->
			{
				this.subState = null;
			}
		}
	}

	function sendTileToHand(tile:Tile):Void
	{
		currentHand.push(tile);
	}

	function setHandTiles():Void
	{
		var centreX = FlxG.width / 2;
		for (i in 0...currentHand.length)
		{
			var tile = currentHand[i];
			var tileX = centreX + ((i - currentHand.length / 2) * 100);
			tile.x = tileX;
			tile.y = FlxG.height - 128;
		}
	}

	function sendTileToPlay(tile:Tile):Void
	{
		currentPlay.push(tile);
	}

	function setPlayTiles():Void
	{
		var centreX = FlxG.width / 2;
		var centreY = FlxG.height / 2;
		for (i in 0...currentPlay.length)
		{
			var tile = currentPlay[i];
			var tileX = centreX + ((i - currentPlay.length / 2) * 100);
			tile.x = tileX;
			tile.y = centreY;
		}
	}

	function isWordValid(word:String):Bool
	{
		return globalState.dictionary.exists(word);
	}
}
