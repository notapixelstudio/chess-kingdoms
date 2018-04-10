## Card structure
### Type
Available types: Piece, Move, Targeted Spell, Global Spell

The *Piece* is the main and most common type of card. When a *Piece* card is played, a new piece is evoked onto the battlefield. The card transforms into the piece itself.

Examples: Pawn (classic), Rook (classic), Eye (a piece that freezes another from far away)


To play a *Move* card a player must select one of their pieces, then move it according to the specifications on the card itself. The card is finally discarded.
(It could be interesting to have *Move* cards that work on enemy pieces).

Examples: Charge (target piece moves and attack 1 forward), Retreat (target piece moves any number of squares back without attacking)


A *Spell* card can either be *Targeted* or *Global*. A *Targeted Spell* affects specific tiles, while a *Global Spell* affects the entire battlefield. After the effect of a *Spell* card is resolved, the card is discarded.

Examples: Steel Plating (2x1 targeted spell, affected pieces with no shield gain a shield), Hole (1x1 targeted spell, target empty tile is removed), Time Trick (global spell, take an extra turn after this one)

### Kingdom
Available kingdoms: Ruby, Emerald, Sapphire, Amber
Cards can also be Neutral

[TBD]

### Side
Available sides: White, Black

This is given to each player by the system randomly, to make players able to tell apart their pieces from enemy ones.

## Piece
Each *Piece* card and its corresponding piece have the following properties:

- kingdom: Enum
- time_units: int (always 1, 2 in special pieces that make two moves per turn)
- hit_points: int (always 1, 2 in special pieces that have a shield)
- abilities: Array<Ability>

These properties are listed on the card.

The piece on the board has these additional properties:

- side: Enum
- time_units_left: int
- hit_points_left: int
- has_ever_moved: bool (used for the special starting move of pawns and castling-like effects)

### Ability

Abilities are the heart of the game. During each player's turn, they can use the time units on their pieces to make them activate an ability.

Types of ability: Move, Attack, Move and Attack, Summon, Command, Cast

[...]