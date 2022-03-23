# Represents the game board
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(9, ' ')
  end

  def mark_board(mark, number)
    return 'nope' if self.board[number - 1] != ' '

    self.board[number - 1] = mark
  end

  def print_board
    puts "#{self.board[0]}|#{self.board[1]}|#{self.board[2]}"
    puts "#{self.board[3]}|#{self.board[4]}|#{self.board[5]}"
    puts "#{self.board[6]}|#{self.board[7]}|#{self.board[8]}"
  end

  def winner?
    possibilities = [[self.board[0], self.board[4], self.board[8]], [self.board[2], self.board[4], self.board[6]]] # Diagonals
    possibilities.concat(self.rows)
    possibilities.concat(self.columns)
    return 'tie' if possibilities.flatten.none?(' ') && possibilities.none? { |poss| poss.all?('x') || poss.all?('o') }

    possibilities.any? { |poss| poss.all?('x') || poss.all?('o') }
  end

  private
  def rows
    (0..2).map { |i| [self.board[3 * i], self.board[3 * i + 1], self.board[3 * i + 2]] }
  end

  def columns
    (0..2).map { |i| [self.board[i], self.board[i + 3], self.board[i + 6]] }
  end
end

# Player objects which choose where to place marks
class Player
  attr_accessor :mark
  attr_writer :next
  attr_reader :name

  def initialize(name)
    @name = name
    @mark = 'o'
    @next = false
  end

  def choose_move(board, number)
    # checking for choosing same spot
    while board.mark_board(self.mark, number) == 'nope'
      puts 'try again'
      number = gets.chomp.to_i
    end

    board.mark_board(self.mark, number)
    self.next = false
  end

  def next?
    @next
  end
end

def new_round(answer)
  if answer == 'y'
    board = Board.new
    first_round = true
  else
    still_playing = false
  end
end

############## main script ##############
still_playing = true

puts 'Enter player name:'
player1 = Player.new(gets.chomp)
puts "Enter second player's name:"
player2 = Player.new(gets.chomp)

board = Board.new
first_round = true

while still_playing
  if first_round
    # First round: decide on player order
    puts 'I will now randomly choose who goes first'
    if rand(2).zero?
      player1.mark = 'x'
      player1.next = true
      puts "#{player1.name} goes first."
    else
      player2.mark = 'x'
      player2.next = true
      puts "#{player2.name} goes first."
    end
    first_round = false
  end

  puts "1|2|3\n4|5|6\n7|8|9"
  print player1.next? ? player1.name : player2.name
  puts ", your move:\n\n"

  if player1.next?
    player1.choose_move(board, gets.chomp.to_i)
    player2.next = true
  else
    player2.choose_move(board, gets.chomp.to_i)
    player1.next = true
  end
  puts board.print_board

  # Checking for winner
  if board.winner?
    puts player1.next? ? "Winner is #{player2.name}" : "Winner is #{player1.name}"
    puts 'Play again? y/n:'
    new_round(gets.chomp.to_i)
  elsif board.winner? == 'tie'
    puts 'Tie!,Play again? y/n:'
    new_round(gets.chomp.to_i)
  end
end
