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


Per ogni reame ci vogliono uno o due temi, da sviluppare in un punto di forza e uno di debolezza
Tipo  La meccanica potrebbe essere che molti suoi pezzi hanno due unità tempo (quindi fanno due azioni per turno). La debolezza potrebbe essere che le mosse sono complessivamente più "corte" in termini di numero di caselle attraversate. Dato il legame giallo-velocità-fulmini farei molto pezzi con mosse oblique, e quindi un altra debolezza potrebbe essere che il giallo tende ad essere colorbound come il classico alfiere
(a partire dal Re... Immaginati un Re che muove solo di uno in obliquo ma che ha un'altra abilità tipo che usa una sua unità tempo per muovere un altro pezzo... Boom)

Esempio per i reami:
- amber (giallo - Elettrico): il giallo per me ha velocità e flessibilità come tema. veloci (2 TU in molti pezzi), obliqui, corti, colorbound - reame di gente furba e atletica
- ruby (rosso - Terra): tough (2 HP in molti pezzi), dritti tipo torre, corti, non-leaping (niente mosse stile cavallo) - reame di gente grossa e forte
- emerald (verde - Erba): swarming (gioca più pezzi del normale), pezzi spesso deboli o addirittura immobili (piante), pezzi che richiedono altri pezzi per funzionare - reame in contatto con la natura stile elfi
- sapphire (blu/rosa - Acqua/Psico): cunning, tante magie per fare mosse e alterare il gioco, combo, pezzi spesso non in grado di attaccare - reame arcano con maghi
nitaku - Yesterday at 13:00
- amethyst (viola - Ghost): mirror strategy, pezzi che copiano le mosse dei pezzi avversari, pezzi clone, molte opzioni per casi specifici, difficile da giocare e aggirabile in molti casi dall'avversario - reame misterioso(edited)
- onyx (nero - Dark): rigioca pezzi morti, non fortissimo all'inizio ma prende sempre più potere man mano che cattura pezzi avversari - reame diabolico sovrannaturale
- pearl (bianco - Acciaio): fortissimo di base, ma estremamente razzista con gli altri reami (non è facile mescolare le sue carte con quelle degli altri colori), carte più costose del normale, carte con effetti negativi per i non-pearl e positive solo per i pearl - reame angelico tipo giorno del giudizio
- quartz (trasparente - Normale): i pezzi normali, con qualche carta semplice. Molto semplici e diretti, usabili con tutti i colori. Non molto forti se usati da soli - reame antico che non esiste più, i suoi abitanti sono diventati raminghi. È buono che tu li possa facilmente includere in un mazzo qualsiasi

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
