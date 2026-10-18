package entities;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import utils.LetterDetails;

class Tile extends FlxSpriteGroup
{
	private var tileSize = 72;
	private var tilePadding = 2;
	private var letterSize = 32;
	private var pointsSize = 16;

	public var letterText:FlxText;
	public var pointsSprite:FlxText;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		var background = new FlxSprite(0, 0);
		background.makeGraphic(tileSize, tileSize, 0xfffff0f0);
		add(background);

		letterText = new FlxText(tilePadding, 0, tileSize - tilePadding, '!');
		letterText.setFormat(null, letterSize, 0xff000000, CENTER, OUTLINE, 0xffffffff);
		// set teh y position to be the centre of the tile
		letterText.y = tileSize / 2 - letterText.height / 2;
		add(letterText);

		pointsSprite = new FlxText(0, 0, 0, "-1");
		pointsSprite.setFormat(null, pointsSize, 0xff000000, LEFT, OUTLINE, 0xffffffff);
		pointsSprite.x = tileSize - pointsSprite.width - tilePadding;
		pointsSprite.y = tileSize - pointsSprite.height - tilePadding;
		add(pointsSprite);
	}

	public function setTileDetails(tieDetails:LetterDetails)
	{
		this.letterText.text = tieDetails.letter;
		this.pointsSprite.text = Std.string(tieDetails.points);
	}
}
