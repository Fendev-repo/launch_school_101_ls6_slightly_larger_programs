require 'pry-byebug'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]] # diagonals
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
# Change constant to either 'computer', 'player', or
# leave it as 'choose' and the user will be prompted for selection.
FIRST_MOVE_CHOICES = ['computer', 'player', 'choose'][2]

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize:
# rubocop:disable Metrics/MethodLength:
def display_board(brd, score_board)
  system 'clear'
  puts "Best of 5! Currently Player is on #{score_board[:player]}"
  puts "and the computer is on #{score_board[:computer]}"
  puts "You're a #{PLAYER_MARKER}.  Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |      |"
  puts "  #{brd[1]}  |   #{brd[2]}  |  #{brd[3]}"
  puts "     |      |"
  puts "_____+_____+_____"
  puts "     |      |"
  puts "  #{brd[4]}  |   #{brd[5]}  |  #{brd[6]}"
  puts "     |      |"
  puts "_____+_____+_____"
  puts "     |      |"
  puts "  #{brd[7]}  |   #{brd[8]}  |  #{brd[9]}"
  puts "     |      |"
end

def display_board_for_winner(score_board)
  system 'clear'
  puts "Great game! So, out of 5 games the"
  puts "final score for Player is #{score_board[:player]}"
  puts "and the Computer got #{score_board[:computer]}"
end
# rubocop:enable Metrics/AbcSize:
# rubocop:enable Metrics/MethodLength:

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def initialize_score
  {
    player: 0,
    computer: 0
  }
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, delim=", ", seperator='or')
  length = arr.length

  case length
  when 0
    ''
  when 2
    "#{arr.first} #{seperator} #{arr.last}"
  else
    last_item = arr.last
    arr = arr.join(delim)
    arr[-1] = "#{seperator} #{last_item}"
    arr.to_s
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose position for piece: #{joinor(empty_squares(brd), ', ')}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  else
    nil
  end
end

# rubocop:disable CyclomaticComplexity:
# rubocop:disable MethodLength:
def computer_places_piece!(brd)
  square = nil
  # Defence
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end
  # Offence
  if !square
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line, brd, PLAYER_MARKER)
      break if square
    end
  end
  # Pick square 5 if its available
  if !square
    square = 5 if empty_squares(brd).include?(5)
  end
  # just pick a square
  if !square
    square = empty_squares(brd).sample
  end
  brd[square] = COMPUTER_MARKER
end
# rubocop:enable CyclomaticComplexity:
# rubocop:enable MethodLength:

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def five_games_won_by_player_or_computer?(score_board)
  if score_board[:player] >= 5 || score_board[:computer] >= 5
    true
  else
    false
  end
end

def ask_player_who_should_go_first
  puts "Would you like to go first? (y or n)"
  reply = gets.chomp.downcase
  reply.start_with?('y') ? 'player' : 'computer'
end

loop do
  board = initialize_board
  score = initialize_score
  first_move = nil

  loop do
    # Play games until player or computer wins x5 games
    # binding.pry
    if FIRST_MOVE_CHOICES == 'choose'
      first_move = ask_player_who_should_go_first
    end

    loop do
      display_board(board, score)

      if first_move == 'computer' || FIRST_MOVE_CHOICES == 'computer'
        computer_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
        display_board(board, score)

        player_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
      end

      if first_move == 'player' || FIRST_MOVE_CHOICES == 'player'
        player_places_piece!(board)
        break if someone_won?(board) || board_full?(board)

        computer_places_piece!(board)
        display_board(board, score)
        break if someone_won?(board) || board_full?(board)
      end
    end

    display_board(board, score)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won!"
      score[detect_winner(board).downcase.to_sym] += 1
    else
      prompt "It's a tie!"
    end

    board = initialize_board
    break if five_games_won_by_player_or_computer?(score)
  end

  display_board_for_winner(score)
  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe! Bye."
