class Game
  def initialize(player1, player2)
      @player1 = Player.new(player1)
      @player2 = Player.new(player2)
      @board = Board.new()
  end

    def who_first
      if rand(2) == 0
        player1.next = true
        player1.mark = 'x'
      else
        player2.next = true
        player1.mark = 'x'
      end
    end
    
end

class Board < Game
  def initialize
    @board = Array.new(9)
  end
end

class Player < Game
  attr_writer :next, :mark

  def initialize(name)
    @name = name
    @next = false
    @mark = 'o'
  end


end


player1 = gets.chomp
player2 = gets.chomp
new_game = Game.new(player1, player2)