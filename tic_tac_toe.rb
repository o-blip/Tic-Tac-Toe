# Rules to a game 
module Game
  def check_first(player2)
    if rand(2).zero?
      self.mark = 'x'
      self.turn = true
      puts "#{self.name} goes first"
    else
      player2.mark = 'x'
      player2.turn = true
      puts "#{player2.name} goes first"
    end
  end

  def round(player2, board)
    puts "1|2|3\n4|5|6\n7|8|9"
    [self, player2].each do |player|
      if player.turn?
        puts "#{player.name}, make your move:"
        player.choose_move(board, gets.chomp.to_i)
      else
        player.turn = true
      end
    end
  end

  def lines(board)
    spots = board.spots
    possibilities = [[spots[0], spots[4], spots[8]],[spots[2], spots[4], spots[6]]]
    (0..2).each do |i|
      possibilities.push([spots[3 * i], spots[3 * i + 1], spots[3 * i + 2]]) # rows
      possibilities.push([spots[i], spots[i + 3], spots[i + 6]]) # columns
    end
    possibilities
  end

  def winner?(player2, board)
    conditions = lines(board)
    
    conditions.each do |line|
      if line.all?('x') || line.all?('o')
        puts self.turn? ? "Winner is #{player2.name}!" : "Winner is #{self.name}"
        return false
      end
    end
    
    if conditions.flatten.none?(' ')
      puts "Tie!"
      return false
    end
    return true
  end
end



# Represents the game board
class Board
  attr_accessor :spots
  include Game
  def initialize
    @spots = Array.new(9, ' ')
  end

  def mark_board(mark, number)
    until spots[number - 1] == ' '
      puts "This spot's taken, choose again"
      number = gets.chomp.to_i
    end
    spots[number - 1] = mark
  end

  def print_board
    puts "#{spots[0]}|#{spots[1]}|#{spots[2]}"
    puts "#{spots[3]}|#{spots[4]}|#{spots[5]}"
    puts "#{spots[6]}|#{spots[7]}|#{spots[8]}"
  end
  
  
end

# Player objects which choose where to place marks
class Player
  include Game
  attr_accessor :mark
  attr_writer :turn
  attr_reader :name

  def initialize(name)
    @name = name
    @mark = 'o'
    @turn = false
  end

  def choose_move(board, number)
    board.mark_board(self.mark, number)
    self.turn = false
  end
  def turn?
    @turn
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
    puts 'Randomly choosing who goes first...'
    player1.check_first(player2)
    first_round = false
  end

  player1.round(player2, board)
  puts board.print_board
  still_playing = player1.winner?(player2, board)
  

end