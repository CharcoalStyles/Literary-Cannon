package utils;

class PlayerDetails
{
	public var name:String;

	private var hp:Int;
  
	private var baseMaxHp:Int;

	public var tileBag:Array<LetterDetails>;

	public var maxHp(get, never):Int;

	function get_maxHp():Int
		return baseMaxHp;

	public function new(name:String, hp:Int, maxHp:Int, tileBag:Array<LetterDetails>)
	{
		this.name = name;
		this.hp = hp;
		this.baseMaxHp = maxHp;
		this.tileBag = tileBag;
	}
}
