require 'sprite.rb'

class Arrow < Sprite

	attr_reader(:c, :r)
	@@arrows = Array.new
			
	def initialize(win,level,c,r,dir)
		win.stuff.each do |x|
			if x.class == Arrow then
				if x.c == c and x.r == r then
					return
				end
			end
		end
	
		super(win,level,c,r)		
		@sheet = Gosu::Image.load_tiles(win, "resources/walls4b.png", 48, 48, true)
		
		@c = c
		@r = r
		@dir = dir
		
		@@arrows.push(self)
		if @@arrows.length > 3 then
			@@arrows[0].die
		end
		
	end
	
	def die
		@@arrows.delete(self)
		super
	end
	
	def draw
		frame = 25 + (@dir - 1) % 4
		@sheet[frame].draw(48 * @c , 48 * @r,0)
	end
	
	def move
	end
	
end