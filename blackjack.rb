#Things to add: split hands

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

class Player
  attr_accessor :name, :money

  def initialize(name)
    @name = name
    @money = 100
  end
end

def deal_a_card(deck)
  return deck.cards[deck.cards.length - 1]
end

def print_player_hand(hand)
  hand.each do |card|
    p "#{card.face} of #{card.suit}"
  end
  p "The value of your hand is #{value_of_hand(hand)}."
  puts
end

def print_dealer_hand(hand)
  hand.each do |card|
    p "#{card.face} of #{card.suit}"
  end
  p "The value of the dealers hand is #{value_of_hand(hand)}."
  puts
end

def value_of_hand(hand)
  value = 0
  hand.each do |card|
    value += card.value
  end

  return value
end

game = true
p "Welcome to Blackjack! Enter your name."
player_name = gets.chomp
player = Player.new(player_name)
p "Hello #{player.name}. You currently have $#{player.money}."
while game == true
  user_turn = true
  dealer_turn = true
  player_hand = []
  dealer_hand = []
  bet_check = false
  puts
  p "Press enter to start a hand. Enter 'Quit' to end."
  input = gets.chomp
  if input.upcase == "QUIT"
    game = false
  else
    system "clear"
    while bet_check == false
      p "Place a bet equal to or lower than your total ammount of money. Minimum $1. (Your amount: $#{player.money})"
      bet = gets.chomp.to_i
      if bet > player.money
        p "You dont have enough money for that bet. Your current total is $#{player.money}"
      elsif bet < 1
        p "Not a valid bet. Try again."
      else
        player.money -= bet
        p "Your current bet is $#{bet}. You have $#{player.money} remaining."
        bet_check = true
      end
    end
    sleep 1.5
    deck = Deck.new
    2.times do
      player_hand << deal_a_card(deck)
      deck.cards.pop()
      dealer_hand << deal_a_card(deck)
      deck.cards.pop()
    end
    p "Your hand:"
    print_player_hand(player_hand)
    sleep 1.5
    dealer_hand_value = dealer_hand[0].value + dealer_hand[1].value
    p "Dealers hand:"
    p "#{dealer_hand[0].face} of #{dealer_hand[0].suit}"
    if dealer_hand_value == 21
      p "#{dealer_hand[1].face} of #{dealer_hand[1].suit}"
      p "Dealer Blackjack, you lose. Your new balence is $#{player.money}."
      user_turn = false
      dealer_turn = false
    else
      p "Unknown card"
      puts
    end
    if value_of_hand(player_hand) == 21
      player.money += (bet * 2)
      p "BLACKJACK!!! You win! Your new balence is $#{player.money}."
      user_turn = false
      dealer_turn = false
    end
    while user_turn == true
      p "Would you like to 'Hit' or 'Stay'?"
      decision = gets.chomp
      puts
      if decision.upcase == "HIT"
        player_hand << deal_a_card(deck)
        deck.cards.pop()
        p "Your new hand:"
        puts
        sleep 1.5
        print_player_hand(player_hand)
        if value_of_hand(player_hand) > 21
          player_hand.each do |card|
            if card.value == 11
              card.value = 1
              sleep 1.5
              p "Your ace is now a one"
              sleep 1.5
              p "Your new hand value is #{value_of_hand(player_hand)}"
              break
            end
          end
          if value_of_hand(player_hand) > 21
            p "Oh no. You bust! Your new balence is $#{player.money}."
            user_turn = false
            dealer_turn = false
          end
        end
      elsif decision.upcase == "STAY"
        p "Your hand was worth #{value_of_hand(player_hand)}"
        puts
        user_turn = false
      else
        p "Not a valid input"
      end
    end
    while dealer_turn == true
      sleep 1.5
      p "Dealers hand:"
      print_dealer_hand(dealer_hand)
      sleep 1.5
      if value_of_hand(dealer_hand) < 17
        p "The dealer takes another card."
        puts
        dealer_hand << deal_a_card(deck)
        deck.cards.pop()
      elsif value_of_hand(dealer_hand) > 21
        dealer_turn = false
        player.money += (bet * 2)
        p "The dealer busts. You win! Your new balence is $#{player.money}."
      else
        dealer_turn = false
        p "The dealer ended with #{value_of_hand(dealer_hand)}"
        puts
        if value_of_hand(dealer_hand) > value_of_hand(player_hand)
          p "The dealer wins. Your new balence is $#{player.money}."
        elsif value_of_hand(dealer_hand) < value_of_hand(player_hand)
          player.money += (bet * 2)
          p "You win! Your new balence is $#{player.money}."
        else
          player.money += bet
          p "Its a wash. Your balence is still $#{player.money}"
        end
      end
    end
  end

  puts
  if player.money == 0
    p "Looks like you are out of money. Game over."
    game = false
  end
  if game
    p "Play again? ('Yes' or 'No')"
    play_again = gets.chomp
    if play_again.upcase == "NO"
      game = false
      p "Looks like you are walking away with $#{player.money}. Nice job #{player.name}!"
    end
  end
end
