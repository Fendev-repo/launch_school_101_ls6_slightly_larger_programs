require_relative 'presentation_and_io_to_terminal'
require_relative 'cards'
MAX_HAND_VALUE = 21
HIT = 'h'
STAY = 's'
WINNING_SCORE = 5

def sleep_for(num_secs)
  sleep(num_secs)
end

def clear_cli
  puts `clear`
end

def count_number_of_games
  {
    player_wins: 0,
    dealer_wins: 0
  }
end

# rubocop:disable Metrics/PerceivedComplexity:
# rubocop:disable Metrics/AbcSize:
# rubocop:disable Metrics/CyclomaticComplexity:
def update_game_won_count(game_count, game_status)
  player_score = game_status[:player_hand]
  dealer_score = game_status[:dealer_hand]
  status = game_status[:current_game_status]

  if dealer_score > player_score && dealer_score <= MAX_HAND_VALUE
    game_count[:dealer_wins] += 1
  elsif status.include?('busted') && dealer_score <= MAX_HAND_VALUE
    game_count[:dealer_wins] += 1
  elsif player_score > dealer_score && player_score <= MAX_HAND_VALUE
    game_count[:player_wins] += 1
  elsif player_score <= MAX_HAND_VALUE && dealer_score > MAX_HAND_VALUE
    game_count[:player_wins] += 1
  end
end
# rubocop:enable Metrics/PerceivedComplexity:
# rubocop:enable Metrics/AbcSize:
# rubocop:enable Metrics/CyclomaticComplexity:

def someone_has_won_5_games?(game_count)
  if game_count[:player_wins] >= WINNING_SCORE
    false
  elsif game_count[:dealer_wins] >= WINNING_SCORE
    false
  else
    true
  end
end

def create_players_hand
  { show_card_1:   nil,
    show_card_2:   nil,
    hit_cards:       [],
    hand_sum_total:  nil,
    player:          true }
end

def create_dealers_hand
  { show_card_1:  nil,
    show_card_2:  nil,
    hit_cards:      [],
    hand_sum_total: nil,
    dealer:         true }
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
  card_1_value = hand[:show_card_1][:numeric_value]
  card_2_value = hand[:show_card_2][:numeric_value]
  card_1_value + card_2_value
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
  # Cacluate best hand option - if hand includes 1 or
  # more aces.
  if aces_in_hand > 0
    grand_total = add_up_total_with_aces(grand_total)
  end
  # Update game status and participant hand, with best hand values
  # option for hand values.
  update_hands(hand, grand_total, game_status)
end

def add_up_total_with_aces(grand_total)
  # Add 10, as the ace is already counted and included as 1.
  if grand_total + 10 <= MAX_HAND_VALUE
    grand_total += 10
  end
  grand_total
end

def how_many_aces_does_hand_have?(hand)
  num_of_aces = 0
  num_of_aces += 1 if this_an_ace?(hand[:show_card_1])
  num_of_aces += 1 if this_an_ace?(hand[:show_card_2])
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

def player_has_stayed?(players_choice)
  players_choice == 's'
end

def player_busted?(player_hand, game_status)
  total_up_hand_for_best_option(player_hand, game_status)
  game_status[:player_hand] > MAX_HAND_VALUE
end

def dealer_has_busted?(dealer_hand, game_status)
  total_up_hand_for_best_option(dealer_hand, game_status)
  game_status[:dealer_hand] > MAX_HAND_VALUE
end

def dealers_first_2_cards_win?(game_status)
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
  players_hand = game_status[:player_hand]

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
  select_2_cards_from_active_deck!(active_deck, player)
  select_2_cards_from_active_deck!(active_deck, dealer)
end

def select_2_cards_from_active_deck!(deck, participant)
  participant[:show_card_1] = choose_random_card!(deck)
  participant[:show_card_2] = choose_random_card!(deck)
end

def dealers_turn_to_choose(active_deck, dealer_hand, game_status)
  player  = game_status[:player_hand]
  dealer  = game_status[:dealer_hand]

  if player && dealer == 20
    game_status[:current_game_status] = 'dealer_stays - game is a draw'
  elsif player >= dealer && dealer < MAX_HAND_VALUE
    deal_next_card(active_deck, dealer_hand)
  end
end

def dealer_is_busted_or_has_bea10_player?(game_status)
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
