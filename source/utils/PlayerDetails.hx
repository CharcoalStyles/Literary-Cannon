package utils;

class PlayerDetails
{
	public var name:String;
	public var hp:Int;
	public var maxHp:Int;
	public var tileBag:Array<LetterDetails>;

	public function new(name:String, hp:Int, maxHp:Int, tileBag:Array<LetterDetails>)
	{
		this.name = name;
		this.hp = hp;
		this.maxHp = maxHp;
		this.tileBag = tileBag;
	}
}
