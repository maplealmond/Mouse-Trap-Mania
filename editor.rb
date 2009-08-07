require 'rubygems'
require 'gosu'
require 'level.rb'

class EditorWindow < Gosu::Window
	def initialize
		super(864, 672, false)
		self.caption = "MouseTrap Mania"
		@level = Level.new(self,ARGV[0])
		@pointer = Gosu::Image.new(self, "resources/pointer.png", true)
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
	end
	
	def update
	end

	def draw
		@level.draw
		@pointer.draw(mouse_x,mouse_y,0)		
	end
	
	def button_down(id)
			case id
		
			when Gosu::Button::KbEscape
			close
			
			when 1 #this is 's', I do not understand why
			@level.save
			
			when 37 #this is 'l'
			@level.load
			draw
			
			when Gosu::Button::MsLeft
			c = mouse_x.to_i / 48
			r = mouse_y.to_i / 48			
			@level.toggle(c,r,'l')
			@level.cache_tiles	
			
			when Gosu::Button::MsRight
			c = mouse_x.to_i / 48
			r = mouse_y.to_i / 48			
			@level.toggle(c,r,'r')
			@level.cache_tiles	
		end
	end
	
end

#PROGRAM START
if ARGV[0].nil? then
	puts "Usage: ruby editor.rb <levelname>"
else
	window = EditorWindow.new
	window.show
end