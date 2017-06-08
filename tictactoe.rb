class TicTacToe
	def initialize
		$tile = {A1: " ", A2: " ", A3: " ",
				 B1: " ", B2: " ", B3: " ",
				 C1: " ", C2: " ", C3: " "}
		
		@turn = 1
		$gameover = false
	end

	def play
		display_board
		first = Player.new("Player 1", "X")
		second = Player.new("Player 2", "0")
		$current_player = first
		until $gameover
			puts "Turn: #{@turn}"
			selection
			display_board
			win
			@turn += 1
			if $current_player == first then $current_player = second else $current_player = first end
		end
		game = TicTacToe.new
		game.play
	end

	def selection
		puts "#{$current_player.name} select your move:"
		move = gets.chomp.upcase.to_sym
		if [:A1, :A2, :A3, :B1, :B2, :B3, :C1, :C2, :C3].include? move then
				if $tile[move] == " " then
					puts "#{$current_player.name} move is #{move}"
					$tile[move] = "#{$current_player.symbol}"
				else
					puts "The tile selected is already taken! Try again!"
					selection
				end
		else
			puts "Your selection (#{move}) is invalid! Try again!"
			selection
		end

	end		 

	def win
		@winning_moves = [
        	[:A1,:A2,:A3],[:B1,:B2,:B3],[:C1,:C2,:C3], #horizontal
        	[:A1,:B1,:C1],[:A2,:B2,:C2],[:A3,:B3,:C3], #vertical
        	[:A1,:B2,:C3],[:A3,:B2,:C1] #diagonal
		]
		@winning_moves.each do |wm|
			if [$tile[wm[0]], $tile[wm[1]], $tile[wm[2]], $current_player.symbol].uniq.count == 1 then
				puts "#{$current_player.name} win!"
				$gameover = true
				break
			end
		end
	end

	def display_board
		puts "
		  1   2   3
		┌───┬───┬───┐
	  A	│ #{$tile[:A1]} │ #{$tile[:A2]} │ #{$tile[:A3]} │
		├───┼───┼───┤
	  B	│ #{$tile[:B1]} │ #{$tile[:B2]} │ #{$tile[:B3]} │
		├───┼───┼───┤
	  C	│ #{$tile[:C1]} │ #{$tile[:C2]} │ #{$tile[:C3]} │
		└───┴───┴───┘
		"
	end

end

class Player
  attr_accessor :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end


game = TicTacToe.new
game.play
