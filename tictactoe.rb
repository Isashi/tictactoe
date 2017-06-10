class TicTacToe
	def initialize
		$tile = {A1: " ", A2: " ", A3: " ",
				 B1: " ", B2: " ", B3: " ",
				 C1: " ", C2: " ", C3: " "}
		
		$turn = 1
		$gameover = false
	end

	def start
		title
		puts "Menu:
		1) 2 players
		2) vs computer
		3) settings
		4) quit	
		"
		puts "Choice:"
		choice = gets.chomp.downcase
		case choice
			when "1","1)","2 players" then pvp
			when "2","2)","vs computer" then computer
			when "3","3)","settings" then settings
			when "4","4)","quit" then quit	
			else puts "Choice not accepted"; gets; start
		end
	end

	def quit
		exit
	end

	def settings
		title
		puts "Settings:
		1) player 1 settings
		2) player 2 settings
		3) computer settings
		4) main menu"
		puts "Choice:"
		choice = gets.chomp.downcase
		case choice
			when "1","1)","player 1" then change($first)
			when "2","2)","player 2" then change($second)
			when "3","3)","computer" then change($computer)
			when "4","4)","main" then start	
			else puts "Choice not accepted"; gets; settings
		end
	end

	def change(player)
		puts "Choose name for #{player.name}:"
		player.name = gets.chomp
		puts "Choose symbol for #{player.name}:"
		symbol = gets.chomp.to_s
		if symbol.length == 1 then
			player.symbol = symbol else
			puts "#{symbol} is too long! New symbol #{symbol[0]}"
			player.symbol = symbol[0]
		end
		puts "Choose color for #{player.name} (red, green, yellow, blue, pink, light_blue):"
		color = gets.chomp.to_s
		if $colors.include? color then player.color = color end
		start
	end

	def pvp
		loop do 
			title
			display_board
			$current_player = $first
			until $gameover
				puts "Turn: #{$turn}"
				selection
				title
				display_board
				$turn += 1
				win
				if $current_player == $first then
				$current_player = $second else
				$current_player = $first end
			end
			play_again?
		end
	end

	def play_again?
		puts "Another game? y/n"
		game = TicTacToe.new
		choice = gets.chomp.downcase
		case choice
			when "n", "no" then game.start
		end
	end

	def computer
		loop do
			title
			display_board
			$current_player = $first
			until $gameover
				puts "Turn: #{$turn}"
				if $current_player == $first then
				selection else
				randomize end
				title
				display_board
				$turn += 1
				win
				if $current_player == $first then
				$current_player = $computer else
				$current_player = $first end
			end
			play_again?
		end
	end

	def randomize
		random = [:A1, :A2, :A3, :B1, :B2, :B3, :C1, :C2, :C3].sample
		if $tile[random] == " " then
			$tile[random] = "#{$current_player.symbol}"
		else
			randomize
		end
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
				gets
				$gameover = true
				break	
			end
		end

		if $turn == 10 && $gameover == false then
			puts "It's a tie!"
			gets
			$gameover = true
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

	def title
		system "clear"
		puts "

	████████╗██╗ ██████╗    ████████╗ █████╗  ██████╗    ████████╗ ██████╗ ███████╗
	╚══██╔══╝██║██╔════╝    ╚══██╔══╝██╔══██╗██╔════╝    ╚══██╔══╝██╔═══██╗██╔════╝
	   ██║   ██║██║            ██║   ███████║██║            ██║   ██║   ██║█████╗  
	   ██║   ██║██║            ██║   ██╔══██║██║            ██║   ██║   ██║██╔══╝  
	   ██║   ██║╚██████╗       ██║   ██║  ██║╚██████╗       ██║   ╚██████╔╝███████╗
	   ╚═╝   ╚═╝ ╚═════╝       ╚═╝   ╚═╝  ╚═╝ ╚═════╝       ╚═╝    ╚═════╝ ╚══════╝".send($colors.sample.to_sym)
		puts ""
	end

end

class Player
  attr_accessor :name, :symbol, :color

  def initialize(name, symbol, color)
    @name = name
    @symbol = symbol
    @color = color
  end

  def symbol
    @symbol.send(color.to_sym)
  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

$colors = ["red", "green", "yellow", "blue", "pink", "light_blue"]
game = TicTacToe.new
$first = Player.new("Player 1", "X", "green")
$second = Player.new("Player 2", "0", "red")
$computer = Player.new("Computer", "$", "blue")
game.start
