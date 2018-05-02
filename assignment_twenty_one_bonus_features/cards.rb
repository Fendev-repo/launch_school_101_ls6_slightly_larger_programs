require 'pry-byebug'
require_relative 'presentation_and_io_to_terminal'
# NO_ALT is used to indicate where non-Ace cards do not have
# an alternative value.
NO_ALT = 0

def suits
  ['hearts', 'diamonds', 'clubs', 'spades']
end

# rubocop:disable Style/AlignArray:
def card_variants
  [['two',  2,  '2 '], ['three', 3, '3 '],
  ['four',  4,  '4 '], ['five',  5, '5 '],
  ['six',   6,  '6 '], ['seven', 7, '7 '],
  ['eight', 8,  '8 '], ['nine',  9, '9 '],
  ['ten',   10, '10'], ['jack', 10, 'J '],
  ['queen', 10, 'Q '], ['king', 10, 'K '],
  ['ace',   1,  'A ']]
end
# rubocop:enable Style/AlignArray:

def create_full_deck_of_playing_cards(suits, card_variants)
  full_deck = suits.each_with_object({}) do |suit, deck|
    card_variants.each do |variant|
      deck["#{variant[0]}_of_#{suit}".to_sym] = { numeric_value: variant[1],
                                                  picture:       variant[2] }
    end
  end
  full_deck
end

def deal_new_deck
  create_full_deck_of_playing_cards(suits, card_variants)
end

def shuffle_deck_for_new_game
  show_card_images
  sleep_for(3)
  clear_cli
  deal_new_deck
end

def make_card
  {
    name:               nil,
    numeric_value:      nil,
    picture:            nil
  }
end
