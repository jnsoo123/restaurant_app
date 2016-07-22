#--------------------------GAME CLASS--------------------------------

class Game
	def initialize(output)
    @output = output
	end
  
  def start(secret)
    @secret = secret
  	@output.puts 'Welcome to Codebreaker!'
  	@output.puts 'Enter guess: '
  end
  
	def guess(guess)
    marker = Marker.new(@secret, guess)
    @output.puts '+'*marker.exact_match_count + '-'*marker.number_match_count
  end
end

#------------------------MARKER CLASS---------------------------------

class Marker
  def initialize(secret, guess)
    @secret = secret
    @guess  = guess
  end
    
  def exact_match_count
    (0..3).inject(0) { |count, index| count + ( exact_match?(index) ? 1 : 0 ) }
  end

  def number_match_count
    (0..3).inject(0) { |count, index| count + ( number_match?(index) ? 1 : 0 ) }
  end

  def exact_match?(index)
    @guess[index] == @secret[index]
  end

  def number_match?(index)
    @secret.include?(@guess[index]) && !exact_match?(index)
  end
  
  def number_match_count
    total_match_count - exact_match_count
  end
  
  def total_match_count
    count = 0
    secret = @secret.split('')
    @guess.split('').inject(0) { |count, n| count + (delete_first(secret, n) ? 1 : 0 ) }
  end
  
  def delete_first(code, n) 
    code.delete_at(code.index(n)) if code.index(n)
  end
end

#--------------------------RSPEC GAME------------------------------------

describe Game do
  let(:output) { double('output').as_null_object }
  let(:game) { Game.new(output) }
  
  describe '#start' do  
    it 'sends a welcome message' do
      output.should_receive(:puts).with('Welcome to Codebreaker!')
      game.start('1234')
    end
    it 'prompts for the first guess' do
      output.should_receive(:puts).with('Enter guess: ')
      game.start('1234')
    end
  end
	
	describe "#guess" do
    it "sends the mark to the output" do
      game.start('1234')
      output.should_receive(:puts).with('++++')
      game.guess('1234')
    end
	end
end

#-------------------------RSPEC MARKER-------------------------------------

describe Marker do
  describe '#exact_match_count' do
    context "with no matches" do
      it 'returns 0' do
        marker = Marker.new('1234','5555')
        marker.exact_match_count.should == 0
      end
    end
    
    context "with 1 exact match" do
      it 'returns 1' do
        marker = Marker.new('1234','1555')
        marker.exact_match_count.should == 1
      end
    end
    
    context "with 1 number match" do
      it 'returns 0' do
        marker = Marker.new('1234','2555')
        marker.exact_match_count.should == 0
      end
    end
    
    context "with 1 exact match and 1 number match" do
      it 'returns 1' do
        marker = Marker.new('1234','1525')
        marker.exact_match_count.should == 1
      end   
    end
  end
  
  describe '#number_match_count' do
    context 'with no matches' do
      it 'returns 0' do
        marker = Marker.new('1234','5555')
        marker.number_match_count.should == 0
      end
    end
    
    context 'with 1 number match' do
      it 'returns 1' do
        marker = Marker.new('1234','2555')
        marker.number_match_count.should == 1
      end
    end
    
    context 'with 1 exact match' do
      it 'returns 0' do
        marker = Marker.new('1234','1555')
        marker.number_match_count.should == 0
      end
    end
    
    context 'with 1 exact match and 1 number match' do
      it 'returns 1' do
        marker = Marker.new('1234','1525')
        marker.number_match_count.should == 1
      end
    end
    
    context 'with 1 exact match duplicated in guess' do
      it 'returns 0' do
#        pending("refactor number_match_count")
        marker = Marker.new('1234','1155')
        marker.number_match_count.should == 0
      end
    end
  end
end

#should_receive -> expect