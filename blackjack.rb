class Card
  attr_accessor :suit, :face, :value

  def initialize(suit, face, value)
    @suit = suit
    @face = face
    @value = value
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    suits = ["Hearts", "Diamonds", "Spades", "Clubs"]
    values = [
      ["Ace", 11],
      ["Two", 2],
      ["Three", 3],
      ["Four", 4],
      ["Five", 5],
      ["Six", 6],
      ["Seven", 7],
      ["Eight", 8],
      ["Nine", 9],
      ["Ten", 10],
      ["Jack", 10],
      ["Queen", 10],
      ["King", 10],
    ]

    suits.each do |suit|
      values.each do |value|
        @cards << Card.new(suit, value[0], value[1])
      end
    end

    @cards.shuffle!
    @cards.shuffle!
    @cards.shuffle!
  end
end

def deal_a_card(deck)
  return deck.cards[deck.cards.length - 1]
end

def print_hand(hand)
  hand.each do |card|
    p "#{card.face} of #{card.suit}"
  end
end

game = true

while game == true
  player_hand = []
  dealer_hand = []
  player_hand_value = 0
  dealer_hand_value = 0
  p "Welcome to Blackjack! Beat the dealer to win."
  p "Press enter to start a hand. Enter 'Quit' to end."
  input = gets.chomp
  if input.upcase == "QUIT"
    game = false
  else
    deck = Deck.new
    # deck.cards.each do |card|
    #   p card
    # end
    2.times do
      player_hand << deal_a_card(deck)
      deck.cards.pop()
      dealer_hand << deal_a_card(deck)
      deck.cards.pop()
    end
    p "Your hand:"
    print_hand(player_hand)

    puts
    dealer_hand_value = dealer_hand[0].value + dealer_hand[1].value
    p "Dealers hand:"
    p "#{dealer_hand[0].face} of #{dealer_hand[0].suit}"
    if dealer_hand_value == 21
      p "#{dealer_hand[1].face} of #{dealer_hand[1].suit}"
      p "Dealer Blackjack, you lose"
    else
      p "Unknown card"
    end
    user_turn = true
    while user_turn == true
      p "Would you like to 'Hit' or 'Stay'?"
      decision = gets.chomp
      if decision.upcase == "HIT"
        player_hand << deal_a_card(deck)
        deck.cards.pop()
        p "Your new hand:"
        print_hand(player_hand)
      elsif decision.upcase == "STAY"
        p
      else
        p "Not a valid input"
      end
    end
  end
end
