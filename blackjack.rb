class BlackJack

	attr_accessor :shoe

	def play

		puts "Let's Play BlackJack!"
		puts "How many decks in the shoe? (Default is 5)"
		shoes = gets.to_i

		if shoes.nil?
			shoes = 5
		end

		@shoe = Shoe.new shoes

		player1_hand = Hand.new
		dealer_hand = Hand.new
		
		puts "Dealing!"
		
		initial_deal player1_hand, dealer_hand
		
		puts "Player 1's intial hand is:"
		puts player1_hand

		puts "Dealer's showing:"
		puts dealer_hand

		# Deal with Blackjack
		if player1_hand.points == 21
			puts "Blackjack!"
			puts "You win!"
			return
		end

		player_turn player1_hand
		
		if( player1_hand.points > 21 )
			puts "You Busted with #{player1_hand.points}. You Lose!"
			return
		end

		dealer_turn dealer_hand

		if(dealer_hand.points > 21 )
			puts "Dealer Busts with #{dealer_hand.points}. You Win!"
		elsif dealer_hand.points > player1_hand.points
			puts "Dealer wins! His #{dealer_hand.points} beats your #{player1_hand.points}"
		elsif dealer_hand.points == player1_hand.points
			puts "Push!"
		else
			puts "You Win! Your #{player1_hand.points} beats dealer's #{dealer_hand.points}"
		end	
				
	end

	def dealer_turn hand

		while(hand.points < 16) do
			card =  @shoe.draw
			hand.push card
			puts "Dealer draws a #{card.name} for #{hand.points}."
		end

		if(hand.soft_seventeen?)
			puts "Dealer hits on soft 17!"
			card =  @shoe.draw
			hand.push card
		end

		hand

	end

	def player_turn hand
			
		points = hand.points		
		puts "Stand, or Hit on #{points}"
		answer = gets.downcase

		if answer.include? "h" 
			
			card = @shoe.draw
			hand.push card
			puts "You picked up a #{card.name}"
			puts hand

			if( hand.points > 21 )
				return
			end

			player_turn hand
		end

		hand		
	end

	def initial_deal dealer_hand, player1_hand
		2.times do
			player1_hand.push @shoe.draw
			dealer_hand.push @shoe.draw
		end
	end

end

class Hand < Array


	def points
		hand_points = my_points true

		if(hand_points > 21 && (self.has_a? 'Ace'))
			hand_points = my_points false
		end

		hand_points
	end

	def soft_seventeen?
		if((self.has_a? 'Ace') && (my_points true == 17))
			return true
		end

		false
	end

	def has_a? rank
		self.each do |card|
			if card.rank == rank
				return true
			end
		end

		false
	end

	private

	def my_points ace_high
		points = 0
		self.each do |card|
			points += card.value ace_high	
		end

		points
	end

end

class Shoe < Array

	def initialize number_of_decks=3
  		
	  	number_of_decks.times {	Deck.new.each { |c| self.push c}}
	  	shuffle!
  	end

	def shuffle!
	  	size.downto(1) { |n| push delete_at(rand(n)) }
		self
	end

	def draw num = 1
    	_draw num, :shift
  	end

private

  def _draw num, operation
    if num.is_a?(Card)
      delete num
    else
      if num == 1
        send(operation)
      else
        cards = []
        num.times { cards << send(operation) }
        cards
      end
    end
  end

end

class Deck < Array

  def initialize
    
    [ 'Club', 'Diamond', 'Heart', 'Spade' ].each do |suit|
      [ 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace' ].each do |rank|
        self << Card.new(rank, suit)
      end
    end
  end

end

class Card

  # Club, Heart, Diamond, Spade
  attr_accessor :rank, :suit

  def initialize rank, suit
    @rank = rank.to_s
    @suit = suit.sub(/s$/, '').capitalize
  end

  def == another_card
    rank == another_card.rank and suit == another_card.suit
  end

  def name
    "#{ rank } of #{ suit }s"
  end

  alias to_s name

  def inspect
    "<Card: \"#{ name }\">"
  end

  def self.parse name
    name = name.to_s.sub(/^the( )?/i, '')

    if name =~ /^(\w+) of (\w+)$/i
      Card.new $1, $2
    elsif name =~ /^(\w+)of(\w+)$/i
      Card.new $1, $2
    end
  end

  def value ace_high=true

  	if ['Jack', 'Queen', 'King'].include? rank 
  		return 10
	end

	if ["Ace"].include? rank
		
		if ace_high 
		 return 11 
		end
		 return 1
	end

  	rank.to_i
  end

  class << self
    alias [] parse
  end

end

module CardConstant
  def const_missing name
    if card = Card.parse(name)
      return card
    else
      super
    end
  end
end

Object.send :extend, CardConstant