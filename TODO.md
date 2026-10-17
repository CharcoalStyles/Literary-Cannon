* [ ] Battle Game (lo-fi vertical slice)
  * [x] Setup
    * [x] Basic dictionary
      * [x] Drop a word list in assets/data/words.txt
      * [x] Load once into a Map<String,Bool> (Assets.getText);
    * [x] Tile data
      * [x] Letter frequency + point value table
  * [ ] Battle model (no UI, just data in PlayState)
    * [ ] Letter "bag": shuffled array of all tiles;
    * [ ] Letter discard: array of tiles used
    * [ ] Hand: 8 tiles, refill to 8 after each play/discard
    * [ ] Player HP / enemy HP (e.g. 30 / 40)
    * [ ] Turn state: PLAYER -> ENEMY -> PLAYER ... -> WIN / LOSE
  * [ ] Basic UI (rectangles + FlxText, placeholder layout)
    * [ ] HP bars/labels for player and enemy
    * [ ] Letter hand (row of clickable tile boxes showing letter + points)
    * [ ] Word work area (row where selected tiles appear, in order)
    * [ ] Bag counter ("Bag: 43")
    * [ ] Buttons: GO, Shuffle hand, Discard
    * [ ] Message line ("Not a word!", "You deal 12", "Enemy hits for 6")
    * [ ] Win / Lose overlay -> click returns to MainMenuState
  * [ ] Gameplay
    * [ ] Basic letter/word gameplay
      * [ ] Basic letter selection + removal
        * [ ] Click hand tile -> moves to work area; click work-area tile -> returns to hand
      * [ ] Hand shuffle (reorders hand only; free, no turn cost)
      * [ ] Discard letters (selected tiles go to discard, redraw; costs the turn)
      * [ ] Go!
        * [ ] Reject if < 2 letters or not in dictionary (keep tiles, show message)
        * [ ] Damage = sum of tile points (x length bonus later); subtract from enemy HP
        * [ ] Spent tiles to discard, refill hand
    * [ ] Enemy turn
      * [ ] One hard-coded enemy, flat attack (e.g. 6) after each player turn, short delay so it's readable
    * [ ] End conditions
      * [ ] Enemy HP <= 0 -> WIN, player HP <= 0 -> LOSE (check after each hit)
