package states;

import flixel.FlxG;
import flixel.FlxState;
import states.subStates.PauseState;
import utils.GlobalState;
import utils.LetterDetails;

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

	var letterBag:Array<LetterDetails> = [];
	var letterDiscard:Array<LetterDetails> = [];

	var currentHand:Array<LetterDetails> = [];
	var currentHandLimit:Int = 8;

	var currentState:Play_State;
	var nextState:Play_State;
	var transitionCountdown:Float;

	var enemyHp:Int = 40;
	var enemyAttack:Int = 6;

	public function new()
	{
		super();
		globalState = FlxG.plugins.get(GlobalState);

		for (letter in globalState.playerDetails.tileBag)
		{
			letterBag.push(letter);
		}

		FlxG.random.shuffle(letterBag);

		currentState = Play_State.Intro;
		transitionCountdown = 10;
	}

	override public function create()
	{
		super.create();
		FlxG.mouse.visible = true;
		FlxG.camera.antialiasing = true;

		globalState = FlxG.plugins.get(GlobalState);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (nextState != null)
		{
			currentState = nextState;
			nextState = null;
		}

		switch (currentState)
		{
			case Intro:
				transitionCountdown -= elapsed;
				if (transitionCountdown <= 0)
				{
					nextState = Play_State.PlayerTurnInit;
				}
			case PlayerTurnInit:
				if (currentHand.length < currentHandLimit)
				{
					var difference = currentHandLimit - currentHand.length;
					for (i in 0...difference)
					{
						currentHand.push(letterBag.shift());
					}
				}
				nextState = Play_State.PlayerTurn;
			case PlayerTurn:
				nextState = Play_State.PlayerAction;
			case PlayerAction:
				nextState = Play_State.EnemyTurn;
			case EnemyTurn:
				nextState = Play_State.End;
			case End:
				transitionCountdown = 0;
		}

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
}
