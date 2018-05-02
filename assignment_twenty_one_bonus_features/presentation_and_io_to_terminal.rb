require 'pry-byebug'
require_relative 'game_logic'
require_relative 'game_logic'

def prompt(msg)
  puts msg
end

def welcome_user_to_the_game
  clear_cli
  prompt ""
  prompt "   Let's Play Twenty-one!"
end

def show_card_images
  card_image_a
  card_image_b
end

def present_hands(player_hand, dealer_hand, game_status, game_count)
  show_dealer_cards(dealer_hand, game_status)
  show_table(game_status)
  show_players_cards(player_hand)
  game_score_board(game_count)
end

def dealers_turn_screen
  clear_cli
  sleep_for(2)
  prompt "Dealers Turn!!"
end

# rubocop:disable Metrics/AbcSize:
# rubocop:disable Metrics/MethodLength:
# rubocop:disable Lint/UselessAssignment:
def show_dealer_cards(dlr_first_hand, game_status)
  c1_pic  = dlr_first_hand[:show_card_one][:picture]
  c1_name = dlr_first_hand[:show_card_one][:name]
  c2_pic  = dlr_first_hand[:show_card_two][:picture]
  c2_name = dlr_first_hand[:show_card_two][:name]
  hits    = dlr_first_hand[:hit_cards].map { |n| n[:name] }
  dealer_hand_total = game_status[:dealer_hand]

  if game_status[:show_all_hands] == false
    c2_pic = '? '
    dealer_hand_total = "unknown"
  end

  prompt "***** Dealers Cards *****"
  prompt "Here are the dealers first two cards"
  prompt "First card  => #{c1_name}"
  prompt "Second card => Dealer to know, you to find out.."
  prompt "+-----+   +-----+"
  prompt "|     |   |     |"
  prompt "|  #{c1_pic} |   |  #{c2_pic} |"
  prompt "|     |   |     |"
  prompt "+-----+   +-----+"
  prompt "                 "
  prompt "Dealers 'hit cards' #{hits}"
  prompt "The dealers total card count is #{dealer_hand_total}"
end

def game_score_board(game_count)
  player_wins = game_count[:player_wins]
  dealer_wins = game_count[:dealer_wins]
  prompt ""
  prompt "======= 5 Game Score ========"
  prompt "Player has won #{player_wins} rounds"
  prompt "Dealer has won #{dealer_wins} rounds"
  prompt ""
end

def show_players_cards(plyr_first_hand)
  c1_pic  = plyr_first_hand[:show_card_one][:picture]
  c1_name = plyr_first_hand[:show_card_one][:name]
  c2_pic  = plyr_first_hand[:show_card_two][:picture]
  c2_name = plyr_first_hand[:show_card_two][:name]
  hits    = plyr_first_hand[:hit_cards].map { |n| n[:name] }
  player_hand_total = plyr_first_hand[:hand_sum_total]

  prompt ""
  prompt "***** Players Cards ***** "
  prompt "First card  => #{c1_name}"
  prompt "Second card => #{c2_name}"

  prompt "+------------+     +-------------+"
  prompt "| #{c1_pic}         |     | #{c2_pic}          |"
  prompt "|            |     |             |"
  prompt "|            |     |             |"
  prompt "|            |     |             |"
  prompt "|            |     |             |"
  prompt "|            |     |             |"
  prompt "|            |     |             |"
  prompt "|         #{c1_pic} |     |          #{c2_pic} |"
  prompt "+------------+     +-------------+"
  prompt "Your 'hit cards' #{hits}"
  prompt "Your current total card count is #{player_hand_total}"
end
# rubocop:enable Metrics/AbcSize:
# rubocop:enable Metrics/MethodLength:
# rubocop:enable Lint/UselessAssignment:

# rubocop:disable Style/UnneededInterpolation:
def show_table(game_status)
  prompt "================================"
  prompt "================================"
  prompt "#{game_status[:current_game_status]}"
  prompt "================================"
  prompt "================================"
end
# rubocop:enable Style/UnneededInterpolation:

def card_image_a
  prompt "                             "
  prompt "  Shuffle, shuffle, shuffle! "
  prompt "                             "
  prompt " +------------------------+  "
  prompt " |                        |  "
  prompt " |                        |  "
  prompt " |         [][][]         |  "
  prompt " |         [][][]         |  "
  prompt " |                        |  "
  prompt " |                        |  "
  prompt " +------------------------+  "
  prompt "                             "
end

def card_image_b
  prompt "                             "
  prompt "      Tap, tap, tap!         "
  prompt "                             "
  prompt "      +------------+         "
  prompt "      |            |         "
  prompt "      |            |         "
  prompt "      |    [][]    |         "
  prompt "      |    [][]    |         "
  prompt "      |    [][]    |         "
  prompt "      |            |         "
  prompt "      |            |         "
  prompt "      +------------+         "
  prompt "                             "
end
