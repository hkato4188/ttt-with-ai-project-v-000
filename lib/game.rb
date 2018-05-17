require 'pry'

class Game

  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [6, 4, 2]
  ]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @player_1 =  player_1
    @player_2 =  player_2
    @board = board
  end

  def current_player
      self.board.turn_count.even? ? player_1 : player_2
  end

  def won?
    WIN_COMBINATIONS.detect do |combo|
      self.board.cells[combo[0]] == self.board.cells[combo[1]] &&
      self.board.cells[combo[1]] == self.board.cells[combo[2]] &&
      self.board.taken?(combo[0]+1)
    end
  end

  def draw?
    self.board.full? && !won?
  end

  def over?
    won? || draw?
  end

  def winner
    won? ? self.board.cells[won?.first] : nil
  end

  def turn
    player = current_player
    current_move = player.move(board)
    if !@board.valid_move?(current_move)
      puts "this is not a valid move, please choose again"
      turn
    else
      @board.update(current_move, player)
    end
    @board.display
  end

  def play
   while !over?
     turn
   end
   if draw?
     puts "Cat's Game!"
   elsif won?
     puts "Congratulations #{winner}!"
   end
  end

end
