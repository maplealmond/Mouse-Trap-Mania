require 'rubygems'
require 'gosu'
require 'level.rb'
require 'mouse.rb'
require 'car.rb'
require 'goat.rb'
require 'arrow.rb'

class GameWindow < Gosu::Window

	attr_accessor(:car, :stuff)	

	def initialize
		super(864, 672, false)
		self.caption = "MouseTrap Mania"	

		@stuff = Array.new
		@level = Level.new(self,ARGV[0])
		@level.load_holes

		@car = Car.new(self,@level,1,1)
		@song = Gosu::Song.new(self, "resources/sound/main.ogg")
	end

	def update
		@stuff.each do |thing|
			thing.update
		end
		exit if @car.life == 0

		@song.play unless @song.playing?
	end

	def draw
		@level.draw
		@stuff.each do |thing|
			thing.draw
		end
	end

	def button_down(id)

		case id
		when Gosu::Button::KbUp
			@car.steer(0)

		when Gosu::Button::KbRight
			@car.steer(1)

		when Gosu::Button::KbDown
			@car.steer(2)

		when Gosu::Button::KbLeft
			@car.steer(3)

		when Gosu::Button::KbEscape
			close

		when 13
			@car.arrowdir = 0

		when 0
			@car.arrowdir = 3

		when 1
			@car.arrowdir = 2

		when 2			
			@car.arrowdir = 1
		end
	end

end


window = GameWindow.new
window.show
