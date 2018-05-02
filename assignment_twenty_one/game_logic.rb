require 'pry-byebug'
require_relative 'presentation_and_io_to_terminal'
require_relative 'cards'
ALT_ACE_VALUE = 11
TEN = 10
ONE = 1
ZERO = 0
TWO = 2
TWENTY = 20
NINE = 9
ELEVEN = 11
MAX_HAND_VALUE = 21

def sleep_for(num_secs)
  sleep(num_secs)
end

def clear_cli
  puts `clear`
end

def game_status_record
  {
    whos_turn:              'players',
    player_staying_on_hand: false,
    player_hand:            nil,
    dealer_hand:            nil,
    show_all_hands:         false,
    current_game_status:    "Hit? or stay?"
  }
end

def this_an_ace?(card)
  card[:name].to_s.include?('ace') ? true : false
end

def add_show_cards_values_together(hand)
  card_one_value = hand[:show_card_one][:numeric_value]
  card_two_value = hand[:show_card_two][:numeric_value]
  card_one_value + card_two_value
end

def total_up_hit_card_values(hand)
  hit_card_value = 0

  if hand[:hit_cards].empty?
    hit_card_value
  else
    hand[:hit_cards].each do |card|
      hit_card_value += card[:numeric_value]
    end
  end
  hit_card_value
end

def hand_busted?(game_status)
  if game_status[:dealer_hand] > MAX_HAND_VALUE
    true
  elsif game_status[:player_hand] > MAX_HAND_VALUE
    true
  else
    false
  end
  game_status
end

def update_hands(hand, grand_total, game_status)
  if hand[:dealer]
    game_status[:dealer_hand] = grand_total
    hand[:hand_sum_total] = grand_total
  elsif hand[:player]
    game_status[:player_hand] = grand_total
    hand[:hand_sum_total] = grand_total
  end
end

def total_up_hand_for_best_option(hand, game_status)
  show_card_totals = add_show_cards_values_together(hand)
  hit_card_total = total_up_hit_card_values(hand)
  grand_total = show_card_totals + hit_card_total
  aces_in_hand = how_many_aces_does_hand_have?(hand)
  # Cacluate best hand option - if hand includes one or
  # more aces.
  if aces_in_hand > ZERO
    grand_total = add_up_total_with_aces(grand_total)
  end
  # Update game status and participant hand, with best hand values
  # option for hand values.
  update_hands(hand, grand_total, game_status)
end

def add_up_total_with_aces(grand_total)
  # Add 10, as the ace is already counted and included as 1.
  if grand_total + TEN <= MAX_HAND_VALUE
    grand_total += TEN
  end
  grand_total
end

def how_many_aces_does_hand_have?(hand)
  num_of_aces = 0
  num_of_aces += 1 if this_an_ace?(hand[:show_card_one])
  num_of_aces += 1 if this_an_ace?(hand[:show_card_two])
  hand[:hit_cards].each do |item|
    num_of_aces += 1 if this_an_ace?(item)
  end
  num_of_aces
end

# rubocop:disable Metrics/CyclomaticComplexity:
# rubocop:disable Metrics/PerceivedComplexity:
def update_status_for_the_table(game_status)
  dealer        = game_status[:dealer_hand]
  player        = game_status[:player_hand]
  player_stayed = game_status[:player_staying_on_hand]

  if dealer == player && player_stayed && dealer <= MAX_HAND_VALUE
    game_status[:current_game_status] = "Hands are even!"
  elsif player_stayed && (dealer > player) && dealer <= MAX_HAND_VALUE
    game_status[:current_game_status] = "Game-over, Dealer won!"
  elsif dealer > MAX_HAND_VALUE && player <= MAX_HAND_VALUE
    game_status[:current_game_status] = "Game-over, Dealer busted - Player won!"
  elsif player > MAX_HAND_VALUE && dealer <= MAX_HAND_VALUE
    game_status[:current_game_status] = "Game-over, Player busted - Dealer won!"
  else
    game_status[:current_game_status] = "Game is live! Players turn"
  end
  game_status
end
# rubocop:enable Metrics/CyclomaticComplexity:
# rubocop:enable Metrics/PerceivedComplexity:

def update_game_status!(game_status, player_hand, dealer_hand)
  total_up_hand_for_best_option(player_hand, game_status)
  total_up_hand_for_best_option(dealer_hand, game_status)
  update_status_for_the_table(game_status)
  game_status
end

def user_wants_to_play_another_round?
  prompt ''
  prompt ' => Would you care for another game? (y or n)'
  reply = gets.chomp.downcase
  unless reply == 'y' || reply == 'n'
    prompt "You entered #{reply} - please type either 'y' or 'n'"
    reply = gets.chomp.downcase
  end
  clear_cli if reply == 'y'
  reply == 'y' ? true : false
end

def player_has_stayed?(players_choice)
  players_choice == 's' ? true : false
end

def player_busted?(player_hand, game_status)
  total_up_hand_for_best_option(player_hand, game_status)
  game_status[:player_hand] > MAX_HAND_VALUE
end

def dealer_has_busted?(dealer_hand, game_status)
  total_up_hand_for_best_option(dealer_hand, game_status)
  game_status[:dealer_hand] > MAX_HAND_VALUE
end

def dealers_first_two_cards_win?(game_status)
  dealers_hand = game_status[:dealer_hand]
  players_hand = game_status[:dealer_hand]
  if dealers_hand > players_hand
    game_status[:current_game_status] = "Dealer Wins!"
    true
  else
    false
  end
end

def hands_are_even_at_max_hand_value(game_status)
  dealers_hand = game_status[:dealer_hand]
  players_hand = game_status[:dealer_hand]

  if dealers_hand == players_hand && dealers_hand == MAX_HAND_VALUE
    game_status[:current_game_status] = "Game is a tie!"
    true
  else
    false
  end
end

def dealer_has_won(game_status)
  player_standing = game_status[:player_staying_on_hand]
  player_hand = game_status[:player_hand]
  dealer_hand = game_status[:dealer_hand]

  if player_standing && (dealer_hand > player_hand)
    true
  # If both player and dealer sit on 20 or 21.
  elsif player_standing && dealer_hand == player_hand
    false
  else
    false
  end
end

def confirm_players_decision
  prompt "Would you like to hit or stay? ('h' for hit, 's' for stay)"
  choice = gets.chomp.downcase
  until choice == 'h' || choice == 's'
    prompt "You entered #{choice} - please enter a ('h' for hit, 's' for stay)"
    choice = gets.chomp.downcase
  end
  choice
end

def deal_next_card(deck, hand)
  hand[:hit_cards] << choose_random_card!(deck)
end

def deal_first_cards!(active_deck, player, dealer)
  select_two_cards_from_active_deck!(active_deck, player)
  select_two_cards_from_active_deck!(active_deck, dealer)
end

def select_two_cards_from_active_deck!(deck, participant)
  participant[:show_card_one] = choose_random_card!(deck)
  participant[:show_card_two] = choose_random_card!(deck)
end

def dealers_turn_to_choose(active_deck, dealer_hand, game_status)
  player  = game_status[:player_hand]
  dealer  = game_status[:dealer_hand]

  if player && dealer == TWENTY
    game_status[:current_game_status] = 'dealer_stays - game is a draw'
  elsif player >= dealer && dealer < MAX_HAND_VALUE
    deal_next_card(active_deck, dealer_hand)
  end
end

def dealer_is_busted_or_has_beaten_player?(game_status)
  player  = game_status[:player_hand]
  dealer  = game_status[:dealer_hand]
  dealer > MAX_HAND_VALUE || dealer > player ? true : false
end

def choose_random_card!(active_deck)
  # Create new card object
  card = make_card
  # Select random card from active deck options
  card_name = active_deck.keys.sample
  # Add name of card to new card
  card[:name] = card_name
  # Now add first/primary card value
  card[:numeric_value] = active_deck[card_name][:numeric_value]
  # Add picture for card
  card[:picture] = active_deck[card_name][:picture]
  # Delete that card from the active deck options
  active_deck.delete(card_name)
  # Return card object
  card
end
