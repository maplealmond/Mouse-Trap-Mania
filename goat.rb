require 'sprite.rb'

class Goat < Sprite
	
	def initialize(win,level,c,r)
		super(win,level,c,r)
		@target = win.car
		@sheet = Gosu::Image.load_tiles(win, "resources/goat.png", 48, 48, false)
		@speed = 3 
	end
	
	def update
		splat
		super
	end
	
	def splat
		dx = (@target.pos[0] - @pos[0])
		dy = (@target.pos[1] - @pos[1])
		if dx.abs < 24 and dy.abs < 24
			@target.radio = rand(4)
		end		
	end
	
	def move
		#avoid hitting a wall
		if ((@pos[0] + @pos[1]) % 48) == 0 then
			redirect
		end
		super
	end
	
	#goats turn when they hit walls
	def redirect
		c = @pos[0] / 48
		r = @pos[1] / 48
		
		tc = c + @delta[@dir][0]
		tr = r + @delta[@dir][1]
				
		if @level.data[tc][tr] == 0 then
			@dir = ( @dir + 1 ) % 4
			redirect
		end
	end
	
	def draw 
		row = [1,2,0,3].at(@dir)
		step = [1,0,1,2].at(((@pos[0] + @pos[1]) % 48) / 12 % 4)
		frame = 3*row + step
		@sheet[frame].draw(@pos[0],@pos[1],1)
	end
	
end
