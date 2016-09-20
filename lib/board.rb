require 'byebug'

class Board
  attr_accessor :cups

  def self.fill_cups
    cups = Array.new(14){ Array.new }

    cups.each.with_index do |cup, index|
      next if index == 6 || index == 13
      cups[index].concat([:stone] * 4)
    end

    cups
  end

  def initialize(name1, name2)
    @cups = self.class.fill_cups
    @side1 = name1
    @side2 = name2
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" unless start_pos.between?(1,12)
  end

  def make_move(start_pos, current_player)
    stones = @cups[start_pos].length
    @cups[start_pos].clear

    next_cup = start_pos + 1
    stones.times do |cup|

      next_cup += 1 if skip_cup?(next_cup, current_player)
      next_cup = next_cup % 14 if next_cup > 13

      @cups[next_cup] << :stone
      next_cup += 1
    end

    render
    next_turn((next_cup - 1) % 14, current_player)
  end

  def skip_cup?(next_cup, current_player)
    next_cup == 13 && current_player == @side1 ||
    next_cup == 6 && current_player == @side2
  end

  def next_turn(ending_cup_idx, current_player)
    if current_player == @side2 && ending_cup_idx == 13
      :prompt
    elsif current_player == @side1 && ending_cup_idx == 6
      :prompt
    elsif @cups[ending_cup_idx].length == 1
      :switch
    else
      ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def cups_empty?
    (0..5).all?{ |cup| @cups[cup].empty? } ||
    (7..12).all?{ |cup| @cups[cup].empty? }
  end

  def winner
    case @cups[6] <=> @cups[13]
    when 1
      @side1
    when -1
      @side2
    when 0
      :draw
    end
  end
end
