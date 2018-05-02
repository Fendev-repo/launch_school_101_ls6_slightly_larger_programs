# Assignment: Twenty-One

## Problem
> Terse problem statement. 
 
CLI game where first to get closest to 21 and not exceed 21 (sum total of collected card values) wins game.

> Constraints 

Game uses normal 52-card deck.  
Deck has standard 4 suits (hearts, diamonds, clubs and spades).  
Card values are [2, 3, 4, 5, 6, 7, 8, 9, 10, jack, queen, king, ace]. 
Goal of Twenty-One is to get the closer to 21 than your opponents/dealer - without exceeding 21;  if > 21 == bust.  
Game consists of a dealer and player.  
Game starts with both players being dealt 2 random cards from deck.  
You can only view one of the dealers cards.
Card values 2-10 worth face values. 
Cards Jack, Queen and King are == 10.   
Card Ace either 1 or 11. 
The value of the ace is determined each time a new card is drawn from deck.  

| Card | Value |
|------|-------|
|2-10  | Face value |
| Jack, Queen, King | 10 |
| Ace | 1 or 11 | 

> Game Play Requirements 

Player and dealer given 2 cards to start.  
Player given option to hit or stay.  
hit = supply another random card from deck.  
stay = no more cards required from dealer for player.  
When the player makes choice to hit or stay, its then the dealers turn to make a choice.  
Dealers logic is to keep self-hitting until its card total >= 17.  
Whoever 'busts' first looses.  
If both player and Dealer have 'stayed' then both players and dealers cards are displayed - and whoever has greater card total wins game.  


> Exclusions 

N/A


## Examples
RE: Dealing cards.  
deal_random_card_from_deck_for(player_one).  
deal_random_card_from_deck_for(dealer).  
=> selects a card from available cards - i.e not already selected.  
=> updates Current Participant Hand Values with obtained cards.   

RE ai.  
as_the_dealer_should_I_take_another_hit_or_stay?(dealer_card_sum_total).  
=> true or false (dealer_card_sum_total >= 17 return ? stay : hit)

RE: game status.  
is_this_game_participant_busted?(player_one).  
is_this_game_participant_busted?(dealer).  
=> true or false (based on participant card sum total)

RE: card availability


RE: score
what_score_is_the_dealer_on().  
=> returns the dealers score { score_no_aces: Integer, score_with_aces Integer }

what_score_is_the_score_for(player_one).  
=> returns the players score { score_no_aces: Integer, score_with_aces Integer }

show_player_game_in_CLI(player_one).   
=> puts presentation of game status - inc score and Ace options if applicable.

RE: Presentation
Dealers Hand.

```ruby
The Dealer is holding these cards.
2 of Spades and ? 
+---+ +---+
| 2 | | ? |
+---+ +---+

+-----+ +-----+
|     | |     |
|  10 | |  A  |  
|     | |     |
+-----+ +-----+
Your holding.
- The first two dealt cards => [ten of diamonds, ace of spades]
- The cards you hit => []
Current sum total of all the cards you now hold = 17.

**If player holding Ace and total score less than 21** 
 Hey, you scored an ACE, so you have options;
  first option ace can be a 1 - so the total could be what_score_is_the_score_for(player_one)
  second option ace can be 11 - so the total could be what_score_is_the_score_for(player_one)     

```

```ruby
The Dealer is shuffling!

** Alternate each image for .5 seconds - for a total of 3 seconds.

shuffle image A:

Shuffle, Shuffle, Shuffle!
+-----------------+
|                 |        
|       /\        |
|       \/        |
|                 |
+-----------------+

screen image B:

Tap, Tap, Tap!
   +------+
   |      |
   |  <>  |
   |      |
   +------+

```



## Data-structures
**Deck = Hash**  
Hash of Key/Value pairs
````ruby 

    full_deck = {
     three_of_hearts: { numeric_value: 3, alt_numeric_value: nil},
     two_of_hearts: { numeric_value: 2, alt_numeric_value: nil},
     ace_of_hearts: { numeric_value: 1, alt_numeric_value: 11
    }}

   whats_left_in_active_game_deck = {
     three_of_spades: { numeric_value: 3, alt_numeric_value: nil},
     two_of_hears: { numeric_value: 2, alt_numeric_value: nil},
     ace_of_diamonds: { numeric_value: 1, alt_numeric_value: 11
    }}

````
** Card  = key/value pair **  
Key = Symbol.

````ruby 
     three: { numeric_value: 3, alt_numeric_value: nil}
````  
Value = Hash.

````ruby  
     { numeric_value: 1, alt_numeric_value: nil}
````

** Current Participant Hand Values  **

```ruby
 
dealer:  { show_card: :ten, 
                     hidden_card: :ace,
                     hit_cards: [],
                     hand_sum_total: Integer}}
 
players: { player_one: { :show_card_one :two, 
                         :show_card_two :seven },
                         hit_cards: [], 
                         hand_sum_total: Integer}  
```


## Algorithm
```ruby 
MAIN_GAME_LOOP (exit if player does not want to play game anymore)
  Welcome the user to the game.
  shuffle_cards (** have this happen for 4 secs) 
  
   DEAL_FIRST_HAND_LOOP (exit if the game is over)
    exit if the_game_is_over?
    deal_first_hand_to(player_one)
    deal_first_hand_to(dealer)
    present_first_hands
   
    PLAY_HIT_STAY_BUST_LOOP (exit if someone has won game)
     exit if is_game_over?
             check_if_game_participant_is_busted(player)
             check_if_game_participant_is_busted(dealer)
     move_game_forward
             ask_for_choice_hit_or_stay(player)
             ask_for_choice_hit_or_stay(dealer)
     exit if is_game_over?
             check_if_game_participant_is_busted(player)
             check_if_game_participant_is_busted(dealer)
    END_PLAY_HIT_STAY_BUST_LOOP

    exit if is_the_game_over?
   END_OF_DEAL_FIRST_HAND_LOOP

  congratulate_winner
  ask_if_player_wants_to_play_another_game?

 EXIT if !confirm_if_user_still_wants_to_play?
END_OF_MAIN_GAME_LOOP
  
```
 

## Code