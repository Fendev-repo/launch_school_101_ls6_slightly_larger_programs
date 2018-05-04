require_relative 'game_logic'
require_relative 'presentation_and_io_to_terminal'
require_relative 'cards'

game_count = count_number_of_games

loop do
  welcome_user_to_the_game

  # prepare_table_for_new_game
  active_deck = shuffle_deck_for_new_game
  player_hand = create_players_hand
  dealer_hand = create_dealers_hand
  game_status = game_status_record
  players_choice = ''

  # Deal the first 2 cards - and present to the player
  deal_first_cards!(active_deck, player_hand, dealer_hand)
  update_game_status!(game_status, player_hand, dealer_hand)
  present_hands(player_hand, dealer_hand, game_status, game_count)

  loop do
    players_choice = confirm_players_decision

    if players_choice == STAY
      game_status[:player_staying_on_hand] = true
      update_game_status!(game_status, player_hand, dealer_hand)

    elsif players_choice == HIT
      deal_next_card(active_deck, player_hand)
      update_game_status!(game_status, player_hand, dealer_hand)
      clear_cli
      present_hands(player_hand, dealer_hand, game_status, game_count)
    end

    break if player_has_stayed?(players_choice)
    break if player_busted?(player_hand, game_status)
  end

  if players_choice == STAY && game_status[:player_hand] <= MAX_HAND_VALUE
    loop do
      break if dealers_first_2_cards_win?(game_status)

      dealers_turn_to_choose(active_deck, dealer_hand, game_status)
      sleep_for(1) # Makes it feel like the dealer is thinking..
      update_game_status!(game_status, player_hand, dealer_hand)
      clear_cli
      present_hands(player_hand, dealer_hand, game_status, game_count)
      break if dealer_has_busted?(dealer_hand, game_status)
      break if dealer_has_won(game_status)
      break if hands_are_even_at_max_hand_value(game_status)
    end
  end

  clear_cli
  update_game_won_count(game_count, game_status)
  game_status[:show_all_hands] = true
  update_game_status!(game_status, player_hand, dealer_hand)
  present_hands(player_hand, dealer_hand, game_status, game_count)
  break unless someone_has_won_5_games?(game_count)
  sleep_for(3)
end
prompt "Thanks for playing the 5 rounds of #{MAX_HAND_VALUE}"
prompt ""
prompt ""
