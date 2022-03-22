# Represents the game board
class Board
  def initialize
    @board = Array.new(3, ' ') { Array.new(3, ' ') }
  end

  def mark_board(mark, number)
    row = (number - 1) / 3
    column = (number - 1) % 3
    @board[row][column] = mark
  end

  def clear_board
    @board = Array.new(3, ' ') { Array.new(3, ' ') }
  end

  def print_board
    puts "#{@board[0][0]}|#{@board[0][1]}|#{@board[0][2]}"
    puts "#{@board[1][0]}|#{@board[1][1]}|#{@board[1][2]}"
    puts "#{@board[2][0]}|#{@board[2][1]}|#{@board[2][2]}"
  end

  def winner?
    possibilities = [[@board[0][0], @board[1][1], @board[2][2]], [@board[0][2], @board[1][1], @board[2][0]]]
    for i in (0..2)
      possibilities.push(@board[i])
      possibilities.push([@board[0][i], @board[1][i], @board[2][i]])
    end
    possibilities.any? { |poss| poss.all?('x') || poss.all?('o') }
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
    board.mark_board(self.mark, number)
    self.next = false
  end
  def next?
    @next
  end
end

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
      puts "#{player1.name} goes first:"
    else
      player2.mark = 'x'
      player2.next = true
      puts "#{player2.name} goes first:"
    end
    first_round = false
  end

  puts 'MAKE YOUR MOVE FOOL:'
  puts "1|2|3\n4|5|6\n7|8|9"

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
    still_playing = false
  end
end
