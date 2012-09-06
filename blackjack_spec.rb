require './blackjack'


describe 'Card' do

	it 'should give its name' do
		card = Card.new 'Ace', 'Clubs'
		card.name.should eql 'Ace of Clubs'
	end

	it 'should give its value' do
		card = Card.new '2', 'Clubs'
		card.value.should eql 2
	end

	it 'should default to aces high' do
		card = Card.new 'Ace', 'Clubs'
		card.value.should eql 11
	end

	it 'can value aces low' do
		card = Card.new 'Ace', 'Clubs'
		card.value(false).should eql 1
	end

end

describe 'Deck' do

	it 'builds a full deck' do
    	deck = Deck.new
    	deck.size.should eql 52
  	end

    it 'has 4 suits' do
	    suits = []
	    Deck.new.each { |card|  suits << card.suit}
	    suits.uniq.count.should eql 4
  	end

end

describe 'Shoe' do

	it 'can have multiple decks' do
		shoe = Shoe.new 5
		shoe.size.should eql 52*5
	end

	it 'defaults to three decks' do
		shoe = Shoe.new
		shoe.size.should eql 52*3
	end

	it 'should be a shuffled shoe' do
		shoe1 = Shoe.new
		shoe2 = Shoe.new
		shoe1.draw.should_not eql shoe2.draw
	end

end

describe 'Hand' do

	it 'should tell me if it holds a certain card' do
		hand = Hand.new
		card = Card.new 'Ace', 'Clubs'
		hand.push card

		(hand.has_a? 'Ace').should eql true
	end

	it 'should give points in the hand' do
		hand = Hand.new
		card = Card.new '2', 'Clubs'
		hand.push card

		card = Card.new '10', 'Clubs'
		hand.push card

		hand.points.should eql 12
	end

	it 'should give default to aces high' do
		hand = Hand.new
		card = Card.new 'Ace', 'Clubs'
		hand.push card

		card = Card.new '10', 'Clubs'
		hand.push card

		hand.points.should eql 21
	end

	it 'should give aces low when necessary' do
		hand = Hand.new
		card = Card.new 'Ace', 'Clubs'
		hand.push card

		card = Card.new '10', 'Clubs'
		hand.push card

		card = Card.new '8', 'Clubs'
		hand.push card

		hand.points.should eql 19
	end

	it 'should recognize a soft seventeen' do
		hand = Hand.new
		card = Card.new 'Ace', 'Clubs'
		hand.push card

		card = Card.new '6', 'Clubs'
		hand.push card

		hand.soft_seventeen?.should eql true
	end

	it 'should recognize a hard seventeen' do
		hand = Hand.new
		card = Card.new '10', 'Clubs'
		hand.push card

		card = Card.new '7', 'Clubs'
		hand.push card

		hand.soft_seventeen?.should eql false
	end


end

describe 'BlackJack' do 

end

